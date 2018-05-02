//
//  Message.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 12.04.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import Foundation

class Message: Codable {
    let message: String?
    let senderID: String
    let receiverID: String
    let date: Date
    let imageURL: String?
    
    init(message: String = "", senderID: String, receiverID: String, date: Date = Date(), imageURL: String = "") {
        self.message = message
        self.senderID = senderID
        self.receiverID = receiverID
        self.date = Date()
        self.imageURL = imageURL
    }
}

