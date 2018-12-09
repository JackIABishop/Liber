//
//  ConfirmEntryController.swift
//  Liber
//
//  Created by Jack Bishop on 08/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class will handle the data that is recieved from the Google Books API call after a barcode scan has been triggered.

import UIKit
import Firebase
import SVProgressHUD

class ConfirmEntryController: UIViewController {
    
    @IBOutlet var titleText: UITextField!
    @IBOutlet var authorText: UITextField!
    @IBOutlet var isbn13Text: UITextField!
    @IBOutlet var isbn10Text: UITextField!
    @IBOutlet var publisherText: UITextField!
    @IBOutlet var publishedText: UITextField!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var thumbnailText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleText.text = currentBookData.title
        authorText.text? = currentBookData.author[0]
        isbn13Text.text = currentBookData.isbn_13
        isbn10Text.text = currentBookData.isbn_10
        publisherText.text = currentBookData.publisher
        publishedText.text = currentBookData.published
        
        //NOTE: - Code below is temoporarily redundant as getting thumbnail is not priority.
        // Check if thumbnail available
        thumbnailText.text = ""
        /*if (currentBookData.thumbnail != nil) {
            
            let testpic = URL(string: "http://i.imgur.com/w5rkSIj.jpg")!
            
            let session = URLSession(configuration: .default)
            
            let downloadPicTask = session.dataTask(with: testpic) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading pic: \(e)")
                } else {
                    // No errors found
                    if let res = response as? HTTPURLResponse {
                        print ("downloaded pic with response code\(res.statusCode)")
                        if let imageData = data {
                            // Convert that data into an image and set it as the thumbnail.
                            let image = UIImage(data: imageData)
                            self.thumbnailImageView.image = image
                        } else {
                            print ("Couldn't get imaeg: image is nil")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            downloadPicTask.resume()
        }*/
    }
    
    //MARK: - Button press handling.
    @IBAction func cancelButtonPressed(_ sender: Any) {
        // Cancel action and return to add screen.
        currentBookData.resetClassData()
        performSegue(withIdentifier: "goToTabView", sender: self)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        // Save the book in user's database.
        SVProgressHUD.show()
        let userEmail = Auth.auth().currentUser?.email!
        let parsedEmail = userEmail?.replacingOccurrences(of: ".", with: ",")
        
        let bookDB = Database.database().reference().child("Users").child(parsedEmail!)
        let bookDictionary = ["User": userEmail,
                              "Book Title": titleText.text!,
                              "Author": authorText.text!,
                              "ISBN-13": isbn13Text.text!,
                              "ISBN-10": isbn10Text.text!,
                              "Publisher": publisherText.text!,
                              "Published": publishedText.text!]
        bookDB.childByAutoId().setValue(bookDictionary) {
        //bookDB.childByAutoId().setValue(bookDictionary) {
            (error, reference) in
            if error != nil {
                print(error as Any)
            } else {
                print("Book saved successfully!")
            }
        }
        
        
        
        SVProgressHUD.dismiss()
        performSegue(withIdentifier: "goToTabView", sender: self)
    }

}
