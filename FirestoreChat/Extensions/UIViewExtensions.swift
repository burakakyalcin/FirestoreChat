//
//  UIViewExtensions.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 22.03.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit

extension UIView {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    func dropShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }
}

extension UITableViewCell {
    static func registerSelf(to tableView: UITableView?) {
        let nib = UINib(nibName: self.className, bundle: Bundle.main)
        tableView?.register(nib, forCellReuseIdentifier: self.className)
    }
}


