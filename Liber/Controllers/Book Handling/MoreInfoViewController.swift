//
//  MoreInfoViewController.swift
//  Liber
//
//  Created by Jack Bishop on 10/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class will handle the MoreInfoViewController, so a user can click on a book entry and view more info about it. 

import UIKit

class MoreInfoViewController: UIViewController {
    
    var bookToView = Book()
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var authorText: UILabel!
    @IBOutlet var isbn13Text: UILabel!
    @IBOutlet var isbn10Text: UILabel!
    @IBOutlet var publisherText: UILabel!
    @IBOutlet var publishedText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting up the view controller.
        titleText.text = bookToView.title
        authorText.text = bookToView.author[0]
        isbn13Text.text = bookToView.isbn_13
        isbn10Text.text = bookToView.isbn_10
        publisherText.text = bookToView.publisher
        publishedText.text = bookToView.published
    }
}
