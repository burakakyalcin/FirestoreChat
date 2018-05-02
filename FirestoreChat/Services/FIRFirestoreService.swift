//
//  FIRFirestoreService.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 22.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import CodableFirebase

protocol FIRFirestoreServiceProtocol: class {
    func getUserSuccess(_ user: User)
    func onError(_ error: Error)
    func sendMessageSuccess()
}

class FIRFirestoreService {
    
    init() {}
    static let shared = FIRFirestoreService()
    
    weak var delegate: FIRFirestoreServiceProtocol?
    
    var listeners = [ListenerRegistration]()
    
    deinit {
        listeners.forEach { (registration) in
            registration.remove()
        }
    }
    
    private func reference(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    
    func create<T: Encodable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            let json = try FirestoreEncoder().encode(encodableObject)
            reference(to: collectionReference).addDocument(data: json)

        } catch {
            print(error)
        }
        
    }
    
    func read<T: Decodable>(from collectionReference: FIRCollectionReference,
                            returning objectType: T.Type,
                            completion: @escaping ([T]) -> Void) {
        
        let listener = reference(to: collectionReference).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else { return }
            
            do {
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try FirestoreDecoder().decode(T.self, from: document.data())
                    objects.append(object)
                }
                completion(objects)
            } catch {
                print(error)
            }
        }
        listeners.append(listener)
    }
    
    func delete<T: Identifiable>(_ identifiableObject: T, in collectionReference: FIRCollectionReference) {
        
        do {
            guard let id = identifiableObject.id else { throw MyError.encodingError }
            reference(to: collectionReference).document(id).delete()
        } catch {
            print(error)
        }
    }
    
    func getUserData(with uid: String) {
        let listener = reference(to: .users).whereField("uid", isEqualTo: uid).addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else { return }
            guard let document = snapshot.documents.first else { return }
            do {
                let user = try FirestoreDecoder().decode(User.self, from: document.data())
                self.delegate?.getUserSuccess(user)
            } catch {
                self.delegate?.onError(error)
            }
        }
        self.listeners.append(listener)
    }
    
    func updateFCMKey(for user: User, key: String) {
        reference(to: .users)
            .whereField("uid", isEqualTo: AppData.sharedInstance.user.uid)
            .limit(to: 1)
            .getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            guard let document = snapshot.documents.first else { return }
                document.reference.setData(["fcmToken": key], options: SetOptions.merge())
        }
    }

    func sendMessage(message: Message, to user: User) {
        
        do {
            let message = try FirestoreEncoder().encode(message)
            let collection = Firestore.firestore().collection("conversations")
            let query = collection.whereField("users.\(AppData.sharedInstance.user.uid)", isEqualTo: true)
            .whereField("users.\(user.uid)", isEqualTo: true).limit(to: 1)
            
            query.getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                guard let document = snapshot.documents.first else { return }
                document.reference.collection("messages").addDocument(data: message)
            }
            self.delegate?.sendMessageSuccess()
        } catch {
            self.delegate?.onError(error)
        }
    }
    
    func getInitialConversation(from userID: String, completion: @escaping ([Message]) -> Void) {
        let collection = Firestore.firestore().collection("conversations")
        let query = collection.whereField("users.\(AppData.sharedInstance.user.uid)", isEqualTo: true)
            .whereField("users.\(userID)", isEqualTo: true)
        
        
        query.getDocuments { (documentSnapshot, error) in
            guard let documentSnapshot = documentSnapshot else { return }
            guard let document = documentSnapshot.documents.first else { return }
            document.reference.collection("messages").getDocuments(completion: { (snapshot, error) in
                guard let snapshot = snapshot else { return }
                do {
                    var messages = [Message]()
                    for document in snapshot.documents {
                        let message = try FirestoreDecoder().decode(Message.self, from: document.data())
                        messages.append(message)
                    }
                    completion(messages)
                } catch {
                    self.delegate?.onError(error)
                }
            })
        }
    }
    
    func getConversation(from userID: String, completion: @escaping ([Message]) -> Void) {
        let collection = Firestore.firestore().collection("conversations")
        let query = collection.whereField("users.\(AppData.sharedInstance.user.uid)", isEqualTo: true)
            .whereField("users.\(userID)", isEqualTo: true)
            
        query.getDocuments { [weak self](snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            if snapshot.documents.count == 0 {
                let dict = ["users": ["\(AppData.sharedInstance.user.uid)" : true, "\(userID)" : true]]
                let newDoc = collection.addDocument(data: dict)
                self?.addListenerToConversationDoc(newDoc, completion: completion)
            } else {
                guard let document = snapshot.documents.first else { return }
                self?.addListenerToConversationDoc(document.reference, completion: completion)
            }
        }
    }
    
    func addListenerToConversationDoc(_ documentRef: DocumentReference, completion: @escaping ([Message]) -> Void) {
        let listener = documentRef.collection("messages").addSnapshotListener({ (snapshot, error) in
            do {
                var messages = [Message]()
                for document in (snapshot?.documents)! {
                    let message = try FirestoreDecoder().decode(Message.self, from: document.data())
                    messages.append(message)
                }
                completion(messages)
            } catch {
                print(error)
            }
        })
        
        self.listeners.append(listener)
    }
}
