//
//  MessageLeftTableViewCell.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 22.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit

class MessageLeftTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    //@IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bubbleImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubbleImageView.image = #imageLiteral(resourceName: "bubble_gray").resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        bubbleImageView.tintColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(with message: Message) {
        /*
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: message.date)
        let dateToConvert = formatter.date(from: dateString)
        formatter.dateFormat = "HH:mm"
        let dateToPrint = formatter.string(from: dateToConvert!)
        */
        
        //timeLabel.text = dateToPrint
        messageLabel.text = message.message
    }
    
}
