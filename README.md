## More about Cidaas

To know more about Cidaas visit [CIDaaS](https://www.cidaas.com)

## Cidaas Documentation 

https://docs.cidaas.de/

## Requirements

    Operating System    :   iOS 9.0 or above
    Xcode               :   8
    Swift               :   3.0
    
## Creating Google App

The following steps are to be followed to create a Google App
1. Go to [Google Developers Console](https://developers.google.com/identity/sign-in/ios/start), and click "Get a Configuration file" button
2. Choose or Create your App Name, fill your Bundle Id and click "Continue to Choose and Configure Services"
3. Click on "Enable Google Sign-In"
4. Click on "Continue to Generate Configuration Files"
5. Download the "GoogleService-Info.plist"

## Getting Started

The followig steps are to be followed to use this CidaasGoogle
1. Drag and drop the downloaded `GoogleService-Info.plist` file in your project
2. Copy and paste the following code in your project's `Info.plist` file

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

3. Drag and drop the [CidaasGoogle.swift](https://github.com/Cidaas/cidaas-google-ios/blob/master/CidaasGoogle/CidaasGoogle.swift) file in your project

```
    Note : Don't edit the file. Otherwise it will not work
```
4. In your project's `AppDelegate` file, imports the module `Google` and `GoogleSignIn` implements the `GIDSignInDelegate`

```swift
    import Google
    import GoogleSignIn
    
    class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
        ...
    }
```

5. Inside the AppDelegate's `sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!)` method, redirect the parameters to the `CidaasGoogle` instance method `didSignIn()`

```swift
    google.didSignIn(signIn, didSignInFor: user, withError: error)
```

6. Inside the AppDelegate's `application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)` method, call the `CidaasGoogle` instance method `configure()` and pass the parameters as `AppDelegate`

```swift
    cidaasGoogleObject.configure(self)
```

7. Inside the AppDelegate's `application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:])` method, redirect the parameters to the `CidaasGoogle` class method `handle` and has to be returned

```swift
    return CidaasGoogle.handle(app, open: url, options: options)
```

8. Create a plist file and fill all the inputs in key value pair. The inputs are below mentioned.

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

            <key>  ClientSecret  </key>
            <string>  Your client secret  </string>

            <key>  RedirectURI  </key>
            <string>  Your redirect uri  </string>

            <key>  ViewType  </key>
            <string>  Your view type  </string>
            
            <key>SocialUrl</key>
            <string>your social url</string>
        </dict>
    </plist>
```
9. Mention the file name in AppDelegate.swift

```swift
    CidaasSDK.plistFilename = "Your file name"
```

10. In your project's `ViewController.swift` file, create an instance for `CidaasGoogle`

```swift
    var cidaas: CidaasGoogle!
```

11. Inside the ViewController's `viewDidLoad()` method, initialise the instance and assign the delegate of `CidaasGoogle` by setting the current ViewController

```swift
    cidaas = CidaasGoogle()
    cidaas.delegate = self
```

12. Call the `cidaasGoogleLogin()` method and receive the access token as callback

```swift
    cidaas.cidaasGoogleLogin { response in
        if response.success == true {
                let alert = UIAlertController(title: "Access Token", message: response.accessToken, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                let alert = UIAlertController(title: "Error", message: response.errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
```

## Sample Code

AppDelegate.swift

```swift
    import UIKit
    import CidaasSDK
    import Google
    import GoogleSignIn

    @UIApplicationMain
    class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
        let google = CidaasGoogle() 
    
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
            google.didSignIn(signIn, didSignInFor: user, withError: error)
        }
        
        var window: UIWindow? 
    
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:     [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
            google.configure(self)
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

ViewController.swift

```swift
    import UIKit

    class ViewController: UIViewController {
    
        var cidaas: CidaasGoogle!
    
        override func viewDidLoad() {
            super.viewDidLoad()
            cidaas = CidaasGoogle()
            cidaas.delegate = self
        }

        @IBAction func btn_google(_ sender: Any) {
            cidaas_google.cidaasGoogleLogin { cidaas_token_response in
                if cidaas_token_response.success == true {
                    CidaasSDK.getUserInfo(accessToken: cidaas_token_response.accessToken!) { cidaas_user_info_response in
                        let alert = UIAlertController(title: "Display Name", message: cidaas_user_info_response.displayName, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else {
                    let alert = UIAlertController(title: "Error", message: cidaas_token_response.errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default))
                    self.present(alert, animated: true, completion: nil)
                }
            }
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
