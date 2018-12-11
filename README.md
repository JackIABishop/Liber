#  Liber

## Summary
This application has been developed as use for a project for the University of Central Lancashire. It contains all of the source files which are being used to make the application (apart from additional libraries using the podfile). 
The application is a iOS based application used to allow users to register an account with Liber, barcode scan a book's ISBN number and retrieve that books details through the use of the Google Books API. The book data will then be stored in the user's account (using Firebase) to enable them to view their book collection from the application. 

## Video Demo
I have created a demo video that can be found at the following link: [Link to YouTube video](https://www.youtube.com/watch?v=uYifEzh8e7E)

## Installation
To build Liber in a development environment, Xcode is required to launch the .xcworkspace. When running the project, it is important to know that the pods required are not included in the project file. To install the pods, locate to the file directory using terminal and run:

```bash
pod init
open podfile 
```

Then add the following pods to the podfile.

```bash
pod 'GoogleBooksApiClient'
pod 'Firebase'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Database'
pod 'SVProgressHUD'
```

Finally, run 

```bash
pod install
```

## Support 
The GitHub Repo can be found here: [Liber Github](https://github.com/JackIABishop/Liber)

If you require any help regarding this project, please contact [Jack](mailto:jack.bish96@gmail.com). 

