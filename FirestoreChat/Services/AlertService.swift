//
//  AlertService.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 22.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}

    static func showAlert(in vc: UIViewController, message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    static func update(_ user: User, in vc: UIViewController, completion: @escaping (User) -> Void) {
        let alert = UIAlertController(title: "Update \(user.name)", message: nil, preferredStyle: .alert)
        alert.addTextField { nameTextField in
            nameTextField.placeholder = "Name"
            nameTextField.text = String(user.name)
        }
        let update = UIAlertAction(title: "Update", style: .default) { _ in
            guard
                let name = alert.textFields?.first?.text
                else { return }
            
            var updatedUser = user
            updatedUser.name = name
            completion(updatedUser)
        }
        alert.addAction(update)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
