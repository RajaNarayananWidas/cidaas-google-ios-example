## More about Cidaas

To know more about Cidaas visit [CIDaaS](https://www.cidaas.com)

## Cidaas Documentation 

https://docs.cidaas.de/

## Requirements

    Operating System    :   iOS 10.0 or above
    Xcode               :   9 
    Swift               :   4.0
    
## Creating Google App

The following steps are to be followed to create a **Google App**

1. Go to [Google Developers Console](https://developers.google.com/identity/sign-in/ios/start), and click **Get a Configuration file** button

2. Choose or Create your App Name, fill your Bundle Id and click **Continue to Choose and Configure Services**

3. Click on **Enable Google Sign-In**

4. Click on **Continue to Generate Configuration Files**

5. Download the **GoogleService-Info.plist**

## Getting Started

The following steps are to be followed to use this **CidaasGoogle**

1. **CidaasGoogle** requires **Cidaas-SDK**, To install it, simply add the following line to your Podfile:

```swift
pod 'Cidaas-SDK', '~> 9.4'
```

2. Drag and drop the downloaded **GoogleService-Info.plist** file in your project

3. Copy and paste the following code in your project's **Info.plist** file and replace the reversed client id with your cliend id which is in **GoogleService-Info.plist** file

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your reversed client id (which is in GoogleService-Info.plist)</string>
        </array>
    </dict>
</array>
```

4. Drag and drop the [CidaasGoogle.swift](https://github.com/Cidaas/cidaas-google-ios/blob/xcode-9-compatability/CidaasGoogle/CidaasGoogle.swift) file in your project

```
Note : Don't edit the file. Otherwise it will not work
```

5. In your project's **AppDelegate.swift** file, imports the module **Google** and **GoogleSignIn** implements the **GIDSignInDelegate**

```swift
import Google
import GoogleSignIn
    
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    let google = CidaasGoogle()
}
```

6. Inside the AppDelegate's **sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)** method, redirect the parameters to the **CidaasGoogle** instance method **didSignIn()**

```swift
func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    google.didSignIn(signIn, didSignInFor: user, withError: error)
}
```

7. Inside the AppDelegate's **application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)** method, call the **CidaasGoogle** instance method **configure()** and pass the parameters as **AppDelegate**

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    google.configure(self)
    return true
}
```

8. Inside the AppDelegate's **application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:])** method, redirect the parameters to the **CidaasGoogle** class method **handle()** and has to be returned

```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return CidaasGoogle.handle(app, open: url, options: options)
}
```

9. Create a plist file and fill all the inputs in key value pair. The inputs are below mentioned.

The plist file should become like this :

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">

<plist version="1.0">
    <dict>
        <key>  AuthorizationURL  </key>
        <string>  Your authorization url  </string>
            
        <key>  TokenURL  </key>
        <string>  Your token url  </string>
        
        <key>  UserInfoURL  </key>
        <string>  Your user info url  </string>
    
        <key>  LogoutURL  </key>
        <string>  Your logout url  </string>

        <key>  ClientID  </key>
        <string>  Your client id  </string>

        <key>  RedirectURI  </key>
        <string>  Your redirect uri  </string>

        <key>  ViewType  </key>
        <string>  Your view type  </string>
            
        <key>SocialUrl</key>
        <string>your social url</string>
    </dict>
</plist>
```

To find AppId and App URls click on [Find App Id and App URLs](https://github.com/Cidaas/cidaas-sdk-ios#user-content-steps-to-find-app-id-and-urls)

10. Mention the file name in **AppDelegate.swift**

```swift
CidaasSDK.plistFilename = "Your file name"
```

11. In your project's **ViewController.swift** file, create an instance for **CidaasGoogle**

```swift
var cidaas: CidaasGoogle!
```

12. Inside the ViewController's **viewDidLoad()** method, initialise the instance and assign the delegate of **CidaasGoogle** by setting the current ViewController

```swift
cidaas = CidaasGoogle()
cidaas.delegate = self
```

13. Call the **cidaasGoogleLogin()** method and receive the cidaas access token information and user information as callback

```swift
cidaas.cidaasGoogleLogin { response in
    // your code
}
```

If you are using **Cidaas-SDK** for web login in your app additionally, no need to manually call the **cidaasGoogleLogin** function, just simply initialise the **CidaasGoogle** class and assign the delegate and enable the **googleSDKEnabled** option

```swift
var cidaas = CidaasGoogle()
cidaas.delegate = self
CidaasSDK.googleSDKEnabled = true
```

## Sample Code

**AppDelegate.swift**

```swift
import UIKit
import Cidaas_SDK
import Google
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {    
    let google = CidaasGoogle()    

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        google.didSignIn(signIn, didSignInFor: user, withError: error)
    }       
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        google.configure(self)
        CidaasSDK.plistFilename = "Cidaas"
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return CidaasGoogle.handle(app, open: url, options: options)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
```

**ViewController.swift**

```swift
import UIKit
import Cidaas_SDK

class ViewController: UIViewController, LoaderDelegate {

    var cidaas: CidaasGoogle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cidaas = CidaasGoogle()
        cidaas.delegate = self
        CidaasSDK.loaderDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn_google(_ sender: Any) {
        cidaas.cidaasGoogleLogin { response in
            if response.issuccess == true {
                
                CidaasSDK.getUserInfo(accessToken: (response.accessTokenEntity?.accessToken)!) { token_response in
                    let alert = UIAlertController(title: "Display Name", message: token_response.displayName, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: response.errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func showLoader() {
        CustomLoader.sharedCustomLoaderInstance.showLoader(self.view, using: nil) { (hud) in
            
        }
    }
    
    func hideLoader() {
        CustomLoader.sharedCustomLoaderInstance.hideLoader(self.view)
    }
}
```

## Screen Shots

<p align="center">

<img src = "https://user-images.githubusercontent.com/26590601/27249732-ed556f96-5339-11e7-8866-01eb216be918.PNG" alt="Screen 1" style="width:40%" height="600">

<img src = "https://user-images.githubusercontent.com/26590601/27729208-8e68d43c-5da2-11e7-850e-366453fb946a.png" alt="Screen 2" style="width:40%" height="600">

</p>

## Help and Support

For more support visit [CIDaaS Support](http://support.cidaas.com/en/support/home)
