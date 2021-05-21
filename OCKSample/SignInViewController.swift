//
//  SignInViewController.swift
//  OCKSample
//
//  Created by Abigail Mortell on 11/30/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn

class SignInViewController : UIViewController {
    
    @IBOutlet var signInButton : GIDSignInButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("Sign in view!")
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        if GIDSignIn.sharedInstance()?.currentUser != nil {
            print("Sign in detected from view controller!")
        } else {
            GIDSignIn.sharedInstance()?.signIn()
        }
        
        
    }
}
