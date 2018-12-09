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
        currentAccountLabel.text = Auth.auth().currentUser?.email
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // Logout the user and return them to the Login screen.
    @IBAction func logoutPressed(_ sender: AnyObject) {
        do {
            SVProgressHUD.show()
            
            try Auth.auth().signOut()
            currentAccount.resetClassData()
            print("Sign out successful")
            performSegue(withIdentifier: "goToLogin", sender: self)
        }
        catch {
            print("ERROR, there was a problem signing out.")
        }
        SVProgressHUD.dismiss()
    }
}
