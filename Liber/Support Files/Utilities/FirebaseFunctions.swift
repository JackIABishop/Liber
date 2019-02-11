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

var organisationCode: String = ""

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
            
            //Get organisation code and save globablly for use throughout the app.
            getOrgCode()
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                completion(true)
            }
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
            
            // Create organisationCode and store in Identifiers table.
            let orgCode = UUID().uuidString
            
            let parsedEmail = registerParameters["Email"]!.replacingOccurrences(of: ".", with: ",")
            let identifierDatabase = Database.database().reference().child("Identifiers").child(parsedEmail)
            identifierDatabase.setValue(orgCode)
            
            // Save users name in User database.
            let userDatabase = Database.database().reference().child("Users").child(orgCode).child("Name")
            userDatabase.setValue(registerParameters["Name"]) {
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

// This function will get the orgCode from the identifiers table from the current logged in user.
func getOrgCode() {
    var orgCode: String = "Not Set"
    let parsedEmail = getFirebaseUserEmail().replacingOccurrences(of: ".", with: ",")
    let identifierDatabase = Database.database().reference().child("Identifiers").child(parsedEmail)
    
    identifierDatabase.observeSingleEvent(of: .value) { (snapshot) in
        if let newUID = snapshot.value as? String {
            orgCode = newUID
        }
        
        print("Users organisation code: \(orgCode)")
        organisationCode = orgCode
    }
}
