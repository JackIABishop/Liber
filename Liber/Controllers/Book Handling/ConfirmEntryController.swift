//
//  ConfirmEntryController.swift
//  Liber
//
//  Created by Jack Bishop on 08/12/2018.
//  Copyright © 2018 Jack Bishop. All rights reserved.
//
//  This class will handle the data that is recieved from the Google Books API call after a barcode scan has been triggered.

import UIKit

class ConfirmEntryController: UIViewController {

    @IBOutlet var textLabel: UILabel!
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textLabel?.text = currentBookData.title // Testing
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
