//
//  StartUpViewController.swift
//  TailGator
//
//  Created by Philip DesJean on 9/21/15.
//  Copyright © 2015 Philip DesJean. All rights reserved.
//

import UIKit
import ParseUI
import ParseFacebookUtilsV4
import FBSDKCoreKit
import Alamofire

class StartUpController: NSObject, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    var window : UIWindow!
    
    init(window : UIWindow) {
        super.init()
        self.window = window
        
        if TGUser.currentUser() != nil {
            updateProfileFromFacebook(false)
            showStoryboard()
        } else {
            showLogin()
        }
    }
    
    func showStoryboard() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let start = storyBoard.instantiateInitialViewController()
        window.rootViewController = start
        window.makeKeyAndVisible()
    }
    
    func showLogin() {
        let loginViewController = PFLogInViewController()
        loginViewController.delegate = self
        loginViewController.fields = PFLogInFields.Facebook
        loginViewController.facebookPermissions = ["user_about_me"]
        
        //        loginViewController.fields = [PFLogInFields.UsernameAndPassword, PFLogInFields.LogInButton, PFLogInFields.SignUpButton]
        
        let logo = UIImage(named: "Logo")
        
        loginViewController.logInView?.logo = UIImageView(image: logo)
        loginViewController.logInView?.logo?.contentMode = .Center
        
        
        //        let signUpViewController = PFSignUpViewController()
        //        signUpViewController.delegate = self
        //        signUpViewController.fields = [PFSignUpFields.UsernameAndPassword, PFSignUpFields.SignUpButton, PFSignUpFields.DismissButton]
        //        signUpViewController.signUpView?.logo = UIImageView(image: logo)
        //        signUpViewController.signUpView?.logo?.contentMode = .Center
        //
        //        loginViewController.signUpController = signUpViewController
        
        window.rootViewController = loginViewController
        window.makeKeyAndVisible()
    }
    
    
    // MARK: - PFLogInViewControllerDelegate
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        print("Cancelled login")
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Login failed: \(error)")
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
//        updateProfileFromFacebook(user.isNew)
        showStoryboard()
    }
    
    
    // MARK: - PFSignUpViewControllerDelegate
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        print("Signup failed: \(error)")
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        showStoryboard()
    }
    
    
    func updateProfileFromFacebook(isNew : Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            FBSDKGraphRequest(graphPath: "me?fields=name,first_name,last_name", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    print("updating profile from facebook")
                    let currentUser = TGUser.currentUser()
                    
                    if isNew {
                        currentUser?.discoverable = true
                    }
                    
                    let userData = result as! NSDictionary
//                    currentUser?.facebookId = userData["id"] as! String
                    currentUser?.firstName = userData["first_name"] as! String
                    currentUser?.lastName = userData["last_name"] as! String
                    currentUser?.name = userData["name"] as! String
                    currentUser?.saveInBackground()
                    
//                    self.updateFacebookImage()
                }
            })
        }
    }
//
//    func updateFacebookImage() {
//        let currentUser = TGUser.currentUser()!
//        let facebookId = currentUser.facebookId
//        let pictureURL = "https://graph.facebook.com/" + facebookId + "/picture?type=square&width=600&height=600"
//        Alamofire.request(.GET, pictureURL).response { (request, response, data, error) -> Void in
//            if error == nil && data != nil {
//                currentUser.image = PFFile(name: "image.jpg", data: data!)
//                currentUser.saveInBackground()
//            } else {
//                print("Failed to update profile image from facebook: \(error)")
//            }
//        }
//    }
}
