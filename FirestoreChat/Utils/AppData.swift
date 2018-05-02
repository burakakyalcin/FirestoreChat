//
//  AppData.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 27.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import Foundation

public class AppData {
    
    var user: User!
    var fcmToken: String = "deneme"
    
    public static let sharedInstance: AppData = {
        let instance = AppData()
        
        return instance
    }()
    
    func setUser(_ user: User) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(encodedData, forKey: "user")
        UserDefaults.standard.synchronize()
        AppData.sharedInstance.user = user
        FIRFirestoreService.shared.updateFCMKey(for: user, key: fcmToken)
    }
    
    func getUser() -> User {
        let decoded = UserDefaults.standard.object(forKey: "user") as! Data
        return NSKeyedUnarchiver.unarchiveObject(with: decoded) as! User
    }
}
