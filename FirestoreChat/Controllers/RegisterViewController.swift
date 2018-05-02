//
//  RegisterViewController.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 27.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        if passwordTextField.text == passwordAgainTextField.text {
            Auth.auth().createUser(withEmail: mailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if let error = error {
                    AlertService.showAlert(in: self, message: error.localizedDescription)
                } else if let user = user {
                    let registeredUser = User(uid: user.uid, name: self.nameTextField.text!, email: user.email!, fcmToken: AppData.sharedInstance.fcmToken)
                    FIRFirestoreService.shared.create(for: registeredUser, in: .users)
                    AppData.sharedInstance.setUser(registeredUser)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        } else {
            AlertService.showAlert(in: self, message: "Please fill all necessary fields")
        }
    }
    
}

extension RegisterViewController {
    func setupView() {
        let gradientLayer = CAGradientLayer().makeGradient(topColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), bottomColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        gradientLayer.frame = view.frame
        view.layer.insertSublayer(gradientLayer, at: 0)
        containerView.dropShadow(offset: .zero, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), radius: 10, opacity: 0.5)
    }
}
