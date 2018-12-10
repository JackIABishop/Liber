#  Bugs
This document will detail any bugs that I have found during the development of Liber. 

## Existing Bugs
### Bug 001
    * Due to the app searching the database asynchornously, the bookcase only loads once the Table is refreshed. I have attempted to work on it for a couple of hours but no avail, so will move on and come back to it later. 
### Bug 002
    * When a barcode is scanned, the ConfirmEntryController opens twice.
### Bug 003
    * Application not yet tested on the range of iOS devices looking for the layout constraints. At the moment, I have prototyped the application and tested using iPhone X. Any other device used before I have conducted proper AutoLayout testing is not promised to be fully functional. 
### Bug 004
    * Email and Password Validation: At the moment, I return an error if there is an error from Firebase. However I do not state what kind of error that is (e.g. invalid username, password not long enough). I plan to add input validation on the app side to give a more informative error code back to the user.

## Fixed Bugs
### Bug 005
    * If there are multiple authors to a book, it only returns one author.
