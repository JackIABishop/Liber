//
//  AccountViewController.swift
//  Liber
//
//  Created by Jack Bishop on 05/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class holds the logic for the Account Tab View. Which is used to handle any information relating to the users account.

import UIKit
import Firebase
import SVProgressHUD

class AccountViewController: UIViewController {

    @IBOutlet var currentAccountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        currentAccountLabel.text = getFirebaseUserEmail()
    }

    // Logout the user and return them to the Login screen.
    @IBAction func logoutPressed(_ sender: AnyObject) {
        SVProgressHUD.show()
        
        if signOutCurrentFirebaseUser() {
            currentAccount.resetClassData()
            print("Sign out successful")
            performSegue(withIdentifier: "goToLogin", sender: self)
        } else {
            print("ERROR, there was a problem signing out.")
        }
        
        SVProgressHUD.dismiss()
    }
}
