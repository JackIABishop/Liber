//
//  FirebaseFunctions.swift
//  Liber
//
//  Created by Jack Bishop on 16/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This file has been created to enable the reusability of code partaining to functionality with Firebase.

import Foundation
import Firebase

// Get the latest error message.
var latestErrorMessage = ""
func getLatestErrorMessageFromFirebaseFunctions() -> String {
    return latestErrorMessage
}

/// Validation
// Function to verify the users login details.
func conductLoginValidation(loginParameters:Dictionary<String, String>) -> Bool {
    // List different types of validation methods, if any fail, return false.
    if (!emailValidation(emailToTest: loginParameters["Email"]!)) {
        latestErrorMessage = "Email not valid."
        return false
    }
    if (loginParameters["Password"]!.count < 6) {
        latestErrorMessage = "Password requires at least 6 characters."
        return false
    }
    return true
}

// Function to verify the users registration details.
func conductRegistrationValidation(registerParameters:Dictionary<String, String>, confirmPassword: String) -> Bool {
    // List different types of validation methods, if any fail, return false.
    let name: String = registerParameters["Name"] ?? ""
    if (name.count == 0) {
        latestErrorMessage = "Enter a name."
        return false
    }
    if (registerParameters["Password"] != confirmPassword) {
        latestErrorMessage = "Passwords do not match."
        return false
    }
    if (!emailValidation(emailToTest: registerParameters["Email"]!)) {
        latestErrorMessage = "Email not valid."
        return false
    }
    if (registerParameters["Password"]!.count < 6) {
     latestErrorMessage = "Password requires at least 6 characters."
        return false
    }
    return true
}

// Function to check if the passed string is a valid email address.
func emailValidation(emailToTest: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: emailToTest)
}

/// Firebase Account Handling.
// Function to handle a login press.
func signInFirebaseUser(loginParameters:Dictionary<String, String>, completion: @escaping (Bool)  -> ()) {
    // Attempt to sign into Firebase.
    Auth.auth().signIn(withEmail: loginParameters["Email"]!, password: loginParameters["Password"]!) { (user, error) in
        if error != nil {
            // Unsuccessful login
            print(error!)
            completion(false)
        } else {
            // Successful login
            print("Login successful")
            completion(true)
        }
    }
}

func registerFirebaseUser(registerParameters:Dictionary<String, String>, completion: @escaping (Bool) -> ()) {
    // Attempt to register the user into Firebase.
    Auth.auth().createUser(withEmail: registerParameters["Email"]!, password: registerParameters["Password"]!) { (user, error) in
        if error != nil {
            // Unsuccessful registration
            print(error!)
            completion(false)
        } else {
            // Successful registration
            print("Registration successful")
            
            // Enter name in users account database.
            
            // Create organisationCode
            let orgCode = getOrgCode(userEmail: registerParameters["Email"]!)
            let bookDatabase = Database.database().reference().child("Users").child(orgCode).child("Name")
            
            bookDatabase.setValue(registerParameters["Name"]) {
                (error, reference) in
                if error != nil {
                    print(error as Any)
                } else {
                    print("Name saves successfully!")
                }
            }
            completion(true)
        }
    }
}

// Return the current users email address from Firebase.
func getFirebaseUserEmail() -> String {
    return (Auth.auth().currentUser?.email ?? nil)!
}

// Attempt to sign out of from the current user.
func signOutCurrentFirebaseUser() -> Bool {
    do {
        try Auth.auth().signOut()
        return true
    } catch {
        return false
    }
}

// This function will generate the organisation code based off their email.
func getOrgCode(userEmail: String) -> String {
    var result = UInt64(5381)
    let buf = [UInt8](userEmail.utf8)
    for b in buf {
        result = 127 * (result & 0x00ffffffffffffff) + UInt64(b)
    }
    return String(result)
}
