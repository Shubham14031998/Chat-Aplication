//
//  ViewController.swift
//  ChatApplication
//
//  Created by Shubham Kaliyar on 16/07/22.
//

import UIKit

class ViewController: UIViewController {
    
    /// objects
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var btnLogin: UIButton!
    
    /// life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imgLogo.tintColor = ThemeManager.headerBackgroundColor
        self.btnLogin.tintColor = ThemeManager.headerBackgroundColor
    }
    
    /// signin button
    /// - Parameter sender: google button
    @IBAction func tappedOnSignin(_ sender: UIButton) {
        SKGoogleLogin.shared.loginToGoogle({ (socialData, message, check) -> (Void) in
            if socialData?.isEmpty ?? true { return }
            self.saveUserDetails(userInfo: socialData ?? [:])
            let nextVC = ResentsUsersVC(nibName: "ResentsUsersVC", bundle: nil)
            self.navigationController?.pushViewController(nextVC, animated: true)
        })
    }
    
    /// save user details on user defaults
    /// - Parameter userInfo: userInfo
    func saveUserDetails(userInfo: [String: Any]){
        let userDetails = UsersState()
        userDetails.userId = String.getstring(userInfo["social_id"])
        userDetails.name = String.getstring(userInfo["name"])
        userDetails.profile_image = String.getstring(userInfo["profile_pic"])
        userDetails.mobile_number = String.getstring(userInfo["email"])
        userDetails.email = String.getstring(userInfo["email"])
        chatUserDefault.setuserDetials(loggedInUserDetails: userDetails)
        ChatHalper.shared.onlineState(state: "1")
    }
}
