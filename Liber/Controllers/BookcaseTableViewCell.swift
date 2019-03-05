//
//  BookcaseTableViewCell.swift
//  Liber
//
//  Created by Jack Bishop on 28/02/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  This class has been created for the custom table view cell. 

import UIKit

class BookcaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookcaseTitleLabel: UILabel!
    @IBOutlet weak var bookcaseAuthorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
