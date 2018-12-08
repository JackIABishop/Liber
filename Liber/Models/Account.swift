//
//  Account.swift
//  Liber
//
//  Created by Jack Bishop on 04/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//

// Handles the data for the user account.
class Account {
    var email : String = ""
    var name : String = ""
    var orgCode : Int = 0
    
    func resetClassData() {
        email = ""
        name = ""
        orgCode = 0
    }
}
