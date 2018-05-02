//
//  MessageLeftWithImageTableViewCell.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 12.04.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit
import SDWebImage

class MessageLeftWithImageTableViewCell: UITableViewCell {

    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    weak var delegate: MessageWithImageTableViewCellProtocol?
    
    var message : Message!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleImageView.image = #imageLiteral(resourceName: "bubble_gray_reversed").resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        bubbleImageView.tintColor = .white
        contentImageView.isUserInteractionEnabled = true
        contentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(with message: Message) {
        self.message = message
        /*let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: message.date)
        let dateToConvert = formatter.date(from: dateString)
        formatter.dateFormat = "HH:mm"
        let dateToPrint = formatter.string(from: dateToConvert!)
        
        timeLabel.text = dateToPrint*/
 
        contentImageView.sd_setImage(with: URL(string: message.imageURL!), placeholderImage: #imageLiteral(resourceName: "placeholder-image"))
    }
    
    @objc
    func imageTapped(gesture: UITapGestureRecognizer) {
        delegate?.imageTapped(imageURL: message.imageURL!)
    }
    
}
