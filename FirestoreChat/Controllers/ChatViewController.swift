//
//  ViewController.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 16.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var receiver: User!
    var messages = [Message]()
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    fileprivate func setupComponents() {
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.keyboardDismissMode = .interactive
        
        MessageLeftTableViewCell.registerSelf(to: tableView)
        MessageRightTableViewCell.registerSelf(to: tableView)
        MessageLeftWithImageTableViewCell.registerSelf(to: tableView)
        MessageRightWithImageTableViewCell.registerSelf(to: tableView)
        
        sendButton.addTarget(self, action: #selector(sendClicked), for: .touchUpInside)
    }
    
    var sendButton : UIButton = {
        var button = UIButton(type: .system)
        return button
    }()
    
    lazy var blackView: UIView = {
        var blackView = UIView(frame: view.frame)
        blackView.backgroundColor = .black
        view.addSubview(blackView)
        return blackView
    }()
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type your message here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    @objc
    func sendClicked() {
        if !(inputTextField.text?.isEmpty)! {
            let message = Message(message: inputTextField.text!, senderID: AppData.sharedInstance.user.uid, receiverID: receiver.uid)
            FIRFirestoreService.shared.sendMessage(message: message, to: receiver)
        }
    }
    
    var containerViewBottomAnchor: NSLayoutConstraint?
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = .white
        
        let uploadImageView = UIImageView()
        uploadImageView.image = #imageLiteral(resourceName: "insert_photo")
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createMediaSourceAlert)))
        containerView.addSubview(uploadImageView)
        
        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        uploadImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        uploadImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        sendButton.setTitle("SEND", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 16).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let seperatorLineView = UIView()
        seperatorLineView.backgroundColor = .lightGray
        seperatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(seperatorLineView)
        
        seperatorLineView.leftAnchor.constraint(lessThanOrEqualTo: containerView.leftAnchor).isActive = true
        seperatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        seperatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        seperatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()

    override var inputAccessoryView: UIView? {
        return inputContainerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect)
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double)
        let contentInset = UIEdgeInsetsMake(0, 0, keyboardFrame.height - 42, 0)
        
        if keyboardFrame.height > 100 {
            tableView.contentInset = contentInset
            tableView.scrollIndicatorInsets = contentInset
            
            UIView.animate(withDuration: keyboardDuration) {
                self.scrollToBottom()
                self.view.layoutIfNeeded()
            }
            
            
        } else {
            containerViewBottomAnchor?.constant = -keyboardFrame.height
            tableView.contentInset.bottom = 8
            
            UIView.animate(withDuration: keyboardDuration) {
                self.view.layoutIfNeeded()
            }
            
        }
        
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double)
        containerViewBottomAnchor?.constant = 0
        tableView.contentInset = .zero
        tableView.scrollIndicatorInsets = .zero
        
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComponents()
        inputTextField.delegate = self
        inputTextField.returnKeyType = .send
        
        FIRFirestoreService.shared.delegate = self
        
        FIRFirestoreService.shared.getConversation(from: receiver.uid) { (messages) in
            self.messages = messages.sorted(by: {$0.date.compare($1.date) == .orderedAscending })
            self.tableView.reloadData()
            self.scrollToBottom()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.keyboardDismissMode = .interactive
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        setupKeyboardObservers()
    }
    
    func scrollToBottom(){
        if messages.count > 0 {
            let indexPath = IndexPath(row: tableView.numberOfRows(inSection: tableView.numberOfSections - 1) - 1  , section: tableView.numberOfSections - 1)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
}

extension ChatViewController : FIRFirestoreServiceProtocol {
    func getUserSuccess(_ user: User) {
        
    }
    
    func onError(_ error: Error) {
        AlertService.showAlert(in: self, message: error.localizedDescription)
    }
    
    func sendMessageSuccess() {
        self.inputTextField.text = ""
    }
    
}

extension ChatViewController: MessageWithImageTableViewCellProtocol {
    func imageTapped(imageURL: String) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DisplayImageViewController") as? DisplayImageViewController
        vc?.imageURL = URL(string: imageURL)
        navigationController?.pushViewController(vc!, animated: true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].senderID == AppData.sharedInstance.user.uid {
            if (messages[indexPath.row].imageURL?.isEmpty)! {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageRightTableViewCell.className, for: indexPath) as! MessageRightTableViewCell
                cell.setCell(with: messages[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageRightWithImageTableViewCell.className, for: indexPath) as! MessageRightWithImageTableViewCell
                cell.setCell(with: messages[indexPath.row])
                cell.delegate = self
                return cell
            }
        }
            
        else {
            if (messages[indexPath.row].imageURL?.isEmpty)! {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageLeftTableViewCell.className, for: indexPath) as! MessageLeftTableViewCell
                cell.setCell(with: messages[indexPath.row])
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: MessageLeftWithImageTableViewCell.className, for: indexPath) as! MessageLeftWithImageTableViewCell
                cell.setCell(with: messages[indexPath.row])
                cell.delegate = self
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (messages[indexPath.row].imageURL?.isEmpty)!{
            return UITableViewAutomaticDimension
        } else{
            return 150
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !(inputTextField.text?.isEmpty)! {
            let message = Message(message: inputTextField.text!, senderID: AppData.sharedInstance.user.uid, receiverID: receiver.uid)
            FIRFirestoreService.shared.sendMessage(message: message, to: receiver)
        }
        return false
    }
}

extension ChatViewController:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    func handleUpload(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(selectedImage)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadToFirebaseStorageUsingImage(_ image: UIImage) {
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploadData = UIImageJPEGRepresentation(image, 0.2) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Failed to upload image: \(String(describing: error?.localizedDescription))")
                    return
                } else {
                    let message = Message(message: "", senderID: AppData.sharedInstance.user.uid, receiverID: self.receiver.uid, date: Date(), imageURL: (metadata?.downloadURL()?.absoluteString)!)
                    FIRFirestoreService.shared.sendMessage(message: message, to: self.receiver)
                }
            }
        }
    }
    
    @objc
    func createMediaSourceAlert() {
        let alert = UIAlertController(title: "Choose a source", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] action in
            self?.handleUpload(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Library", style: .default, handler: { [weak self] action in
            self?.handleUpload(.photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
