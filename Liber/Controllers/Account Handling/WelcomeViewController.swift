//
//  WelcomeViewController.swift
//  Liber
//
//  Created by Jack Bishop on 04/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  Class for the opening welcome view controller.

import UIKit

class WelcomeViewController: UIViewController {
  
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createGradientLayer(view: view)
    
    // Setting up button appearence.
    registerButton.layer.cornerRadius = 10
    registerButton.clipsToBounds = true
    loginButton.layer.cornerRadius = 10
    loginButton.clipsToBounds = true
  }
}

