# Changelog

## Version 1.0.0
    * Signing the current version of Liber as v1.0.0, the final version for the deliverable 2 deadline of the project.

## Version 0.2.4
    * Creation of test plans, using Xcodes testing features. 
    * Splitting up of project code files to implement proper MVC architecture. 
    * Change to code comments, keeping a consistent style through the code; following similar concepts to the ones in this Stack Overflow thread: https://softwareengineering.stackexchange.com/questions/17766/what-are-your-thoughts-on-periods-full-stops-in-code-comments.
    * General code clean up - Removing acronyms, according to style guide (https://github.com/raywenderlich/swift-style-guide).
    * The app now provides a display screen that will display a message if there are no books in the users bookcase.

## Version 0.2.3
    * Enable the ability to delete a user's bookcase. 
    * Change some design elements of the app. 
    * Addition of book cover in moreInfoController, first viewable in the confirmEntryViewController after scanning a book.
    * Implemented custom tableView cells in BookcaseViewController. 
    * Implemented a check to see if a subscribed bookcase has been removed, if so, remove from account.
    * Allowed the user to sort the ordering of bookcase entries. 

## Version 0.2.2
    * Fix to names not loading when viewing organisation details. 
    * User can now see organisation code from the account tab. 
    * Added iPad functionality, by changing the use of action sheet. 

## Version 0.2.1 
    * Fix to organisation names being erased in tableView when searching. 
    * Fixed Issue #7: Incorrect way of database loading. Fix: Overhall of completion handlers when using Firebase calls, optimising the load times of the application.

## Version 0.2.0
    * Introducing Organisations, allowing the user to subscribe to other user's databases.
    * True deletion of account authentication data, instead of just deleting the user's book database.

## Version 0.1.2 
    * Change to manualAddViewController to force a Book title to be entered. 
    * Fix of different coloured Navigation Bars by adding a same coloured view behind each one. 
    * Change to book entry system, now accessible from the BookcaseViewController.
    * Fixed Issue #6: Cannot add two books simultaneously.

## Version 0.1.1 
    * Added search functionality in the bookcase. 
    * Added Manual Entry functionality.

## Version 0.1.0
    * Addition of icons for the tab controllers. 
    * Added the ability to delete a book from the MoreInfoViewController.
    * Core functionality has been completed, hence launching v0.1.0.

## Version 0.0.18
    * Added a reset password option in the login screen. 
    * Added a change password option in the account screen.  
    * Added the ability to delete the users account.

## Version 0.0.17
    * Fixed Issue #2: BookcaseViewController TableView Data Cells not refreshing on load.
    * Fixed Issue #5: TableViewDataSource incorrect implementation.

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
