//
//  ViewController.swift
//  GoogleExample
//
//  Created by ganesh on 29/06/17.
//  Copyright © 2017 Widas. All rights reserved.
//

import UIKit
import Cidaas_SDK

class ViewController: UIViewController, LoaderDelegate {

    var cidaas_google : CidaasGoogle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cidaas_google = CidaasGoogle()
        cidaas_google.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        CidaasSDK.loaderDelegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btn_cidaas_google_login(_ sender: Any) {
        cidaas_google.cidaasGoogleLogin { cidaas_token_response in
            if cidaas_token_response.issuccess == true {
                CidaasSDK.getUserInfo(accessToken: (cidaas_token_response.accessTokenEntity?.accessToken)!) { cidaas_user_info_response in
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

    func showLoader() {
        CustomLoader.sharedCustomLoaderInstance.showLoader(self.view, using: nil) { (hud) in
            
        }
    }
    
    func hideLoader() {
        CustomLoader.sharedCustomLoaderInstance.hideLoader(self.view)
    }
}

