//
//  MessageRightWithImageTableViewCell.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 12.04.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit
import SDWebImage

protocol MessageWithImageTableViewCellProtocol: class {
    func imageTapped(imageURL: String)
}

class MessageRightWithImageTableViewCell: UITableViewCell {

    @IBOutlet weak var bubbleImageView: UIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    
    var message : Message!
    
    weak var delegate: MessageWithImageTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        bubbleImageView.image = #imageLiteral(resourceName: "bubble_blue_reversed").resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
        bubbleImageView.tintColor = .white
        contentImageView.isUserInteractionEnabled = true
        contentImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:))))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(with message: Message) {
        self.message = message
        /*
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: message.date)
        let dateToConvert = formatter.date(from: dateString)
        formatter.dateFormat = "HH:mm"
        let dateToPrint = formatter.string(from: dateToConvert!)
         */
        
        //timeLabel.text = dateToPrint
        
        contentImageView.sd_setImage(with: URL(string: message.imageURL!), placeholderImage: #imageLiteral(resourceName: "placeholder-image"))
    }
    
    @objc
    func imageTapped(gesture: UITapGestureRecognizer) {
        delegate?.imageTapped(imageURL: message.imageURL!)
    }
}
