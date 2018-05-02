//
//  Fwift.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 16.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String? { get set }
}

class User: NSObject, Codable, Identifiable, NSCoding {
    var id: String?
    var uid: String
    var name: String
    var email: String
    var fcmToken: String
    
    init(uid: String, name: String, email: String, fcmToken: String) {
        self.uid = uid
        self.name = name
        self.email = email
        self.fcmToken = fcmToken
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let uid = aDecoder.decodeObject(forKey: "uid") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let fcmToken = aDecoder.decodeObject(forKey: "fcmToken") as! String
        self.init(uid: uid, name: name, email: email, fcmToken: fcmToken)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: "uid")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(fcmToken, forKey: "fcmToken")
    }
}
