//
//  MessageHeaderTableViewCell.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 27.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit

class MessageHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
