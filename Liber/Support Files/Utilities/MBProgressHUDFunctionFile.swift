//
//  MBProgressHUDFunctionFile.swift
//  MBProgressHudTest
//
//  Created by Jack Bishop on 20/01/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  The functions in this file will allow for easier implementation of the MBProgressHUD API.

import Foundation
import MBProgressHUD

func indeterminateLoad(displayText: String, view: UIView) {
  let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
  loadingNotification.mode = MBProgressHUDMode.indeterminate
  loadingNotification.label.text = displayText
  
  loadingNotification.show(animated: true)
}

func hideHUD(view: UIView) {
  MBProgressHUD.hideAllHUDs(for: view, animated: true)
}

