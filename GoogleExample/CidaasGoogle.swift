//
//  CidaasGoogle.swift
//  CidaasGoogle
//
//  Created by ganesh on 16/06/17.
//  Copyright © 2017 Widas. All rights reserved.
//

import Foundation
import Google
import GoogleSignIn
import Cidaas_SDK

public class CidaasGoogle : UIViewController, GIDSignInUIDelegate, CidaasGoogleDelegate {
    
    var cal : CallbackEntity = CallbackEntity()
    static var callback: ((CallbackEntity)->())?
    var googleViewController: UIViewController!
    var delegate: UIViewController {
        get {
            return self.delegate
        }
        set (delegate) {
            CidaasSDK.googleDelegate = self
        }
    }
    
    
    public func googleLogout() {
        CidaasGoogle.logout()
    }
    
    public func didSignIn(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if user != nil {
            cal.accessTokenEntity = AccessTokenEntity()
            cal.accessTokenEntity?.accessToken = user.authentication.accessToken
            cal.issuccess = true
            cal.errorMessage = nil
        }
        else {
            cal.accessTokenEntity = nil
            cal.issuccess = false
            cal.errorMessage = "Response is failure"
        }
        CidaasGoogle.callback!(cal)
    }
    
    public func cidaasGoogleLogin(callback: @escaping (CallbackEntity) -> ()) {
        login { loginResponse in
            if loginResponse.issuccess == true {
                print ("Access Token : \(loginResponse.accessTokenEntity?.accessToken ?? "NIL")")
                CidaasSDK.CALLBACK = callback
                let cidaas_sdk = CidaasSDK()
                cidaas_sdk.getAccessTokenBySocial(tokenOrCode: (loginResponse.accessTokenEntity?.accessToken)!, provider: Provider.google.rawValue, givenType: GivenType.token.rawValue)
            }
            else {
                print ("Error Message : \(loginResponse.errorMessage ?? "NIL")")
                self.cal.accessTokenEntity = nil
                self.cal.issuccess = loginResponse.issuccess
                self.cal.errorMessage = loginResponse.errorMessage
                callback(self.cal)
                
            }
        }

    }
    
    public func googleLogin(callback: @escaping (CallbackEntity) -> ()) {
        login { loginResponse in
            if loginResponse.issuccess == true {
                print ("Access Token : \(loginResponse.accessTokenEntity?.accessToken ?? "NIL")")
                self.cal.accessTokenEntity = loginResponse.accessTokenEntity
                self.cal.issuccess = loginResponse.issuccess
                self.cal.errorMessage = loginResponse.errorMessage
                callback(self.cal)
            }
            else {
                print ("Error Message : \(loginResponse.errorMessage ?? "NIL")")
                self.cal.accessTokenEntity = nil
                self.cal.issuccess = loginResponse.issuccess
                self.cal.errorMessage = loginResponse.errorMessage
                callback(self.cal)

                
            }
        }
    }
    
    private func login(callback : @escaping(CallbackEntity)->()) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        CidaasGoogle.callback = callback
    }
    
    public class func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    public func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(viewController, animated: true, completion: nil)
            googleViewController = viewController
        }
    }
    
    public func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        googleViewController.dismiss(animated: true, completion: nil)
    }
    
    func configure(_ appDelegate : AppDelegate) {
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        assert(configureError == nil, "Error configuring Google services: \(String(describing: configureError))")
        GIDSignIn.sharedInstance().delegate = appDelegate
    }
    
    public class func handle(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
}
