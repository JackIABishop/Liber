//
//  BookcaseTableViewCell.swift
//  Liber
//
//  Created by Jack Bishop on 28/02/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//

import UIKit

class BookcaseTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookcaseTitleLabel: UILabel!
    @IBOutlet weak var bookcaseAuthorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
