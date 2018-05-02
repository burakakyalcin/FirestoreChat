//
//  CAGradientLayerExtensions.swift
//  FirestoreChat
//
//  Created by Burak Akyalcin on 16.04.2018.
//  Copyright © 2018 Burak Akyalcin. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    func makeGradient(topColor: UIColor, bottomColor: UIColor) -> CAGradientLayer {
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x:0.5, y: 1.0)
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        return gradientLayer
    }
    
    func whiteToGrayGradient() -> CAGradientLayer {
        
        let startColor = UIColor(red: (255 / 255.0), green: (255 / 255.0), blue: (255 / 255.0), alpha: 1)
        let endColor = UIColor(red: (219 / 255.0), green: (219 / 255.0), blue: (219 / 255.0), alpha: 1)
        
        let gradientColors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: -1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x:1.0, y: 0.0)
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]
        
        return gradientLayer
    }
}
