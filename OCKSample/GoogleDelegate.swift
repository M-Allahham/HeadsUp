//
//  GoogleDelegate.swift
//  OCKSample
//
//  Created by Abigail Mortell on 11/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import GoogleSignIn

class GoogleDelegate : UIViewController, GIDSignInDelegate, ObservableObject {
    @Published var signedIn: Bool = false
    
    //Sign in function through Google Delegate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        //Signed in!
        print("Success")
        //Change view to the CareKitView
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let manager = appDelegate.synchronizedStoreManager!
        let careViewController = UINavigationController(rootViewController: CareViewController(storeManager: manager))
        let top = UIApplication.shared.keyWindow?.rootViewController
        top?.present(careViewController, animated: true, completion: nil)
        signedIn = true
    }
}
