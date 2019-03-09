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

class AccountViewController: UIViewController {
  
  // Instance Variables
  let userEmail = getFirebaseUserEmail()
  
  // Linking UI Elements
  @IBOutlet var currentAccountLabel: UILabel!
  @IBOutlet var orgCodeLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.accessibilityIdentifier = "accountView" // Idenfitifier required to UI testing.
    
    // Do any additional setup after loading the view.
    currentAccountLabel.text = userEmail
    orgCodeLabel.text = organisationCode
  }
  
  // Logout the user and return them to the Login screen.
  @IBAction func logoutPressed(_ sender: AnyObject) {
    indeterminateLoad(displayText: "Logging out", view: self.view)
    
    logOut()
    
    hideHUD(view: self.view)
  }
  
  // MARK: - Button Presses
  @IBAction func changePasswordPressed(_ sender: Any) {
    // Launch Change Password Functionality.
    // Ask the user for their current password.
    let changePasswordAlert = UIAlertController(title: "Change password", message: "Enter your current password", preferredStyle: .alert)
    
    // Creating the different text field options.
    changePasswordAlert.addTextField { (currentPassword) in
      currentPassword.placeholder = "Current Password"
      currentPassword.isSecureTextEntry = true
    }
    
    changePasswordAlert.addTextField { (newPassword: UITextField!) in
      newPassword.placeholder = "New Password"
      newPassword.isSecureTextEntry = true
    }
    
    changePasswordAlert.addTextField { (confirmPassword: UITextField!) in
      confirmPassword.placeholder = "Confirm Password"
      confirmPassword.isSecureTextEntry = true
    }
    
    // Conduct validation on the entered password.
    changePasswordAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    changePasswordAlert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (alert) in
      let currentPassword = changePasswordAlert.textFields![0] // Force unwrap is safe because I know it exists.
      let newPassword = changePasswordAlert.textFields![1]
      let confirmPassword = changePasswordAlert.textFields![2]
      
      // Check if the currentPassword is correct.
      let user = Auth.auth().currentUser
      let credential: AuthCredential = EmailAuthProvider.credential(withEmail: self.userEmail, password: currentPassword.text!)
      
      indeterminateLoad(displayText: "Hold on...", view: self.view)
      user?.reauthenticateAndRetrieveData(with: credential, completion: { (authResult, error) in
        if let error = error {
          hideHUD(view: self.view)
          
          // An error happened.
          print("Error reauthenticating")
          print(error)
          
          // Launch error alert.
          let errorAlert = UIAlertController(title: "Error", message: "Incorrect password", preferredStyle: .alert)
          errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
          self.present(errorAlert, animated: true, completion: nil)
          
          
        } else {
          // User re-authenticated successfully.
          print("correct password")
          
          // Check if both newPasswords match.
          if newPassword.text == confirmPassword.text {
            if (newPassword.text?.count)! > 6 {
              user?.updatePassword(to: newPassword.text!, completion: { (error) in
                if error != nil {
                  hideHUD(view: self.view)
                  
                  // Error updating password.
                  // Launch error alert.
                  let errorAlert = UIAlertController(title: "Error", message: "Cannot update password", preferredStyle: .alert)
                  errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive))
                  self.present(errorAlert, animated: true, completion: nil)
                } else {
                  hideHUD(view: self.view)
                  
                  // Successful update.
                  // Launch error alert.
                  let errorAlert = UIAlertController(title: "Success", message: "Password changed", preferredStyle: .alert)
                  errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                  self.present(errorAlert, animated: true, completion: nil)
                }
              })
            } else {
              hideHUD(view: self.view)
              
              // New password is not long enough.
              // Launch error alert.
              let errorAlert = UIAlertController(title: "Error", message: "New password is not long enough", preferredStyle: .alert)
              errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive))
              self.present(errorAlert, animated: true, completion: nil)
            }
          } else {
            hideHUD(view: self.view)
            
            // Passwords do not match.
            // Launch error alert.
            let errorAlert = UIAlertController(title: "Error", message: "Passwords do not match", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "OK", style: .destructive))
            self.present(errorAlert, animated: true, completion: nil)
          }
        }
      })
    }))
    
    self.present(changePasswordAlert, animated: true, completion: nil)
  }
  
  
  @IBAction func deleteAccountPressed(_ sender: Any) {
    // Trigger warnings for deleting account using an action pop up box.
    let optionMenu = UIAlertController(title: "Warning", message: "Deleting your account is a destructive action, your digital bookcase will be deleted.", preferredStyle: UIAlertController.Style.alert)
    
    // Creation options.
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
    
    let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive) { (alert) in
      self.deleteAccount()
    }
    
    // Adding the actions to the menu.
    optionMenu.addAction(cancelAction)
    optionMenu.addAction(confirmAction)
    
    // Present the menu to the screen.
    self.present(optionMenu, animated: true, completion: nil)
  }
  
  @IBAction func deleteBookcasePressed(_ sender: Any) {
    // Trigger warnings for deleting bookcase using an action pop up box.
    let optionMenu = UIAlertController(title: "Warning", message: "Deleting your bookcase is a destructive action, you will not be able to recover your data.", preferredStyle: UIAlertController.Style.alert)
    
    // Creation options.
    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel)
    
    let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertAction.Style.destructive) { (alert) in
      self.deleteBookcase()
    }
    
    // Adding the actions to the menu.
    optionMenu.addAction(cancelAction)
    optionMenu.addAction(confirmAction)
    
    // Present the menu to the screen.
    self.present(optionMenu, animated: true, completion: nil)
  }
  
  // Remove all books in user's bookcase.
  func deleteBookcase() {
    indeterminateLoad(displayText: "Deleting account", view: self.view)
    
    // Remove user bookcase data.
    Database.database().reference(withPath: "Users").child(organisationCode).child("Collection").removeValue()
    
    print("Bookcase Deleted")
    hideHUD(view: self.view)
  }
  
  // Logout the current user.
  func logOut() {
    if signOutCurrentFirebaseUser() {
      print("Sign out successful")
      performSegue(withIdentifier: "goToLogin", sender: self)
    } else {
      print("ERROR, there was a problem signing out.")
    }
  }
  
  // Delete the users account.
  func deleteAccount() {
    indeterminateLoad(displayText: "Deleting account", view: self.view)
    
    let user = Auth.auth().currentUser
    
    // Log the user out.
    logOut()
    
    // Remove user bookcase data.
    let parsedEmail = userEmail.replacingOccurrences(of: ".", with: ",")
    Database.database().reference(withPath: "Users").child(organisationCode).removeValue()
    
    // Remove UID.
    Database.database().reference(withPath: "Identifiers").child(parsedEmail).removeValue()
    
    // Remove user authentication.
    user?.delete { error in
      if let error = error {
        // Error
        print(error)
        print("Error deleting account")
      }
    }
    
    print("account deleted")
    hideHUD(view: self.view)
  }
  
  // Open the OrganisationViewController.
  @IBAction func viewOrgsButtonPressed(_ sender: Any) {
    performSegue(withIdentifier: "goToOrganisation", sender: self)
  }
}

