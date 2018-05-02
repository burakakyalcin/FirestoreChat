//
//  LoginViewController.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 27.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import CodableFirebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        FIRFirestoreService.shared.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mailTextField.text = "adrian@mutu.com"
        passwordTextField.text = "123456"
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error {
                AlertService.showAlert(in: self, message: error.localizedDescription)
            } else if let user = user {
                FIRFirestoreService.shared.getUserData(with: user.uid)
            }
        }
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension LoginViewController: FIRFirestoreServiceProtocol {
    func onError(_ error: Error) {
        AlertService.showAlert(in: self, message: error.localizedDescription)
    }
    
    func sendMessageSuccess() {
    }
    
    
    func getUserSuccess(_ user: User) {
        AppData.sharedInstance.setUser(user)
        FIRFirestoreService.shared.listeners.forEach { (listener) in
            listener.remove()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension LoginViewController {
    func setupView() {
        let gradientLayer = CAGradientLayer().makeGradient(topColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), bottomColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1))
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        containerView.dropShadow(offset: .zero, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), radius: 10, opacity: 0.5)
    }
}
