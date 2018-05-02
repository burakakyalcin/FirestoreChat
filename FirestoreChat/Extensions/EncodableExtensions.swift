//
//  EncodableExtensions.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 22.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import Foundation

enum MyError: Error {
    case encodingError
}

extension Encodable {
    /*
    func toJSON(excluding keys: [String] = [String]()) throws -> [String : Any] {
        let objectData = try JSONEncoder().encode(self)
        let jsonObject = try JSONSerialization.jsonObject(with: objectData, options: [])
        guard var json = jsonObject as? [String : Any] else { throw MyError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        
        return json
    }
    */
}
