//
//  LoginViewController.swift
//  Twitter
//
//  Created by Alex Rich on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "currentlyLoggedIn") == true {
            self.performSegue(withIdentifier: "loginPath", sender: self)
        }
    }
    
    @IBAction func loginUser(_ sender: Any) {
        let loginURL = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginURL, success: {
            UserDefaults.standard.set(true, forKey: "currentlyLoggedIn")
            self.performSegue(withIdentifier: "loginPath", sender: self)
        }, failure: { (Error) in
            print("login error")
        })
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
