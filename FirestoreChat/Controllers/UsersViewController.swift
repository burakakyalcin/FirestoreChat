//
//  UsersViewController.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 27.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit
import FirebaseAuth

class UsersViewController: UITableViewController {

    var allUsers: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func showLoginScreen() {
        let loginVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationController = UINavigationController(rootViewController: loginVC)
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.backgroundColor = UIColor.clear
        navigationController.navigationBar.tintColor = .red
        present(navigationController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil {
            showLoginScreen()
        } else {
            setupComponents()
            
            FIRFirestoreService.shared.read(from: .users, returning: User.self) { (users) in
                self.allUsers = users.filter({$0.uid != AppData.sharedInstance.user.uid}).sorted(by: {$0.name.compare($1.name) == .orderedAscending })
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        /*FIRFirestoreService.shared.listeners.forEach { (registration) in
            registration.remove()
        }*/
    }
    @IBAction func signOutAction(_ sender: UIBarButtonItem) {
        do {
            FIRFirestoreService.shared.updateFCMKey(for: AppData.sharedInstance.user, key: "")
            UserDefaults.standard.removeObject(forKey: "user")
            try Auth.auth().signOut()
            showLoginScreen()
            
        } catch {
            AlertService.showAlert(in: self, message: "Error occured, try again")
        }
    }
    
    func setupComponents() {
        MessageHeaderTableViewCell.registerSelf(to: tableView)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allUsers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageHeaderTableViewCell.className, for: indexPath) as! MessageHeaderTableViewCell
        cell.nameLabel.text = "\(allUsers[indexPath.row].name)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.title = "\(allUsers[indexPath.row].name)"
        vc.receiver = allUsers[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }

}
