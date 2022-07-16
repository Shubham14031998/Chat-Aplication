
//
//  SKGoogleLogin.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import Foundation
import GoogleSignIn

typealias GoogleSignInClosure = ((([String:Any]?),String,Bool) -> (Void))?

class SKGoogleLogin: NSObject {
    
    static var shared:SKGoogleLogin = SKGoogleLogin()
    fileprivate var googleDidSignIn: GoogleSignInClosure = nil
    
    private override init() {
        super.init()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate   = self
        GIDSignIn.sharedInstance().shouldFetchBasicProfile = true
    }
    
    func loginToGoogle(_ handler:GoogleSignInClosure) -> Void  {
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
        self.googleDidSignIn = handler
    }
    
}


//MARK:- ----------Google SignIn Delegate Methods----------

extension SKGoogleLogin: GIDSignInDelegate  , GIDSignInUIDelegate {
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            self.googleDidSignIn?(nil,error.localizedDescription, false)
            print("\(error.localizedDescription)")
            return
        }
        let userData = ["social_id" : String.getstring(user.userID),
                        "email"      : String.getstring(user.profile.email),
                        "name"       : String.getstring(user.profile.name),
                        "profile_pic":"\(String.getstring(user.profile.imageURL(withDimension: 1280).absoluteString))",
                        "social_type":"Google Login"]
        self.googleDidSignIn?(userData,"Login Successfull", true)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
        self.googleDidSignIn?(nil,error.localizedDescription,false)
        print(error.localizedDescription)
    }
}
