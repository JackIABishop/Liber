#  Liber

## Github Page
For a full picture of the repository over teh course of the development, the Github page can be found [here](https://github.com/JackIABishop/Liber).

## Summary
This application has been developed as use for a project for the University of Central Lancashire. It contains all of the source files which are being used to make the application (apart from additional libraries using the podfile). 
The application is a iOS based application used to allow users to register an account with Liber, barcode scan a book's ISBN number and retrieve that books details through the use of the Google Books API. The book data will then be stored in the user's account (using Firebase) to enable them to view their book collection from the application. 

## Video Demo
The first deliverable demo video van be found at the following link: [Link to YouTube video](https://www.youtube.com/watch?v=uYifEzh8e7E)

## Installation
To build Liber in a development environment, Xcode is required to launch the .xcworkspace. When running the project, it is important to know that the pods required are not included in the project file. To install the pods, locate to the file directory using terminal and run:

To build Liber in a development environment, clone the repository and launch terminal. Navigate to the cloned directory and run the following command:

```bash
pod install
```

Terminal will download all of the necessary dependencies that the application requires to run. Then you can launch the 'Liber.xcworkspace' file.

## Support 
If you require any help regarding this project, please contact [Jack](mailto:jack.bish96@gmail.com). 

## Roadmap
    * Potentially add a 'Author' controller, to list all Authors in collection, then have the functionality to click on an author and list their books. 
    * Add a 'location' element to each book, allowing a user to specify where abouts the book can be found. 
