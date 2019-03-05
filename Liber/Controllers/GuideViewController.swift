//
//  GuideViewController.swift
//  Liber
//
//  Created by Jack Bishop on 08/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class handles any logic for the Guide View Controller, which will be triggerd when a user registers to the application.

import UIKit

class GuideViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    createGradientLayer(view: self.view)
  }
}

