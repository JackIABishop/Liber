//
//  BookcaseViewController.swift
//  Liber
//
//  Created by Jack Bishop on 03/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class holds the logic for the Bookcase Tab View Controller. 

import UIKit
import Firebase
import SVProgressHUD

class BookcaseViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Load user's bookcase data.
        SVProgressHUD.show()
        SVProgressHUD.dismiss()
    }


}

