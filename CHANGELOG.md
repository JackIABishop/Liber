# Changelog

## Version 0.0.17
    * Fix Issue #2: BookcaseViewController TableView Data Cells not refreshing on load.
    * Fix Issue #5: TableViewDataSource incorrect implementation

## Version 0.0.16
    * Fixed Issue #1: ConfirmEntryController opens twice.
    * Added Code for MoreInfoViewController to view more info about a book selection.
    * Changed LaunchScreen copyright to 2019.
    * Removal of SVProgressHUD and addition of MBProgressHUD as I have more control of the loading animations. 
    * Addition of MBProgressHUDFunctionFile, a customer library that I created to make calls to the MBProgressHUD API easier. 

## Version 0.0.15
    * Splitting code into reusable libraries, addition of 'FirebaseFunctions.swift' in SupportFiles/Utilities/
    * Removal of BUGS.md as it is no longer required, any further issues will be recorded in the 'Issues' section in Bitbucket.
    * Changed the RegisterViewController to require two confirmation passwords.
    * Added validation for the login / register pages to give a better error message to the user. 

## Version 0.0.14
    * Removal of acronyms in source for more readable code. 
    * Creation of Roadmap section in README.md
    * Modification of loading screen to include UCLan in copyright notice. 

## Version 0.0.13
    * Addition of ViewEntryController to view more info about a book entry. NOTE:- Not fully working yet. 
    * Addition of README.md
    * Fixed BUG 005.

## Version 0.0.12
    * Implemented digital bookcase with TableView, in a later revision, this will be a custom table view.
    * Reading from user's bookcase.
    * When a user registers, a help screen will be shown to give a quick rundown on what they can do with the application. 
    * Addition of BUGS.md file, to report known bugs as an acknowledgment 

## Version 0.0.11
    * Fix to save data to the database in the correct way.

## Version 0.0.10
    * Addition of ConfirmEntryController implementation, allowing the user to check the book information before it is added to the database.
    * Completed functionality to save confirmed book data into Firebase. 

## Version 0.0.9
    * Emergency fix of published API key.

## Version 0.0.8
    * Use of Google Books API to search for book data.
    * Recieve API call JSON and store in temporary Book class.

## Version 0.0.7
    * Addition of Automatic Barcode entry with ADFoundation.
    * Using the Account class to save the users email address for user later on. NOTE: This method will likely be changed by a direct call from Firebase.

## Version 0.0.6 
    * Added comments to each file to explain their purpose. 
    * Addition of 'logout' functionality from the Account Tab View. 
    * Moved CHANGELOG.md to top level folder. 

## Version 0.0.5
    * Linked the Welcome Screen, Account Handling and TabView controllers together.
    * Implemented Register and Login input entry logic. 
    * Completed Register and Account system functionality.
    * Addition of pods: SVProgressHUD
    * Addition of GuideViewController, designed as a one time only view for new users.

## Version 0.0.4
    * Project connecting with Firebase database.
    * Storyboarding of Welcome Screen.
    * Addition of class files for Account Handling and Tab View Controllers
    * Added data models for Account and Book class. 

## Version 0.0.3 
    * Installing pods: Firebase Core & Database, Google Books API

## Version 0.0.2
    * Creation of project files and folder structure.

## Version 0.0.1 
    * Initial Commit and creation of project.
