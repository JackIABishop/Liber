//
//  GradientLayer.swift
//  Liber
//
//  Created by Jack Bishop on 25/02/2019.
//  Copyright © 2019 Jack Bishop. All rights reserved.
//
//  Using this function for a globally accessible gradient properties.

import UIKit

var gradientLayer: CAGradientLayer!

// Blue
let colorTop = UIColor(red: 192.0 / 255.0, green: 220.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor
let colorBottom = UIColor(red: 3.0 / 255.0, green: 150.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0).cgColor

// Grey
//let colorTop = UIColor(red: 144.0 / 255.0, green: 247.0 / 255.0, blue: 255.0 / 236.0, alpha: 1.0).cgColor
//let colorBottom = UIColor(red: 50.0 / 255.0, green: 204.0 / 255.0, blue: 188.0 / 255.0, alpha: 1.0).cgColor

//
//let colorTop = UIColor(red: 249.0 / 255.0, green: 119.0 / 255.0, blue: 148.0 / 236.0, alpha: 1.0).cgColor
//let colorBottom = UIColor(red: 98.0 / 255.0, green: 58.0 / 255.0, blue: 162.0 / 255.0, alpha: 1.0).cgColor

func createGradientLayer(view: UIView) {
    gradientLayer = CAGradientLayer()
    
    gradientLayer.frame = view.bounds
    
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    
    view.layer.insertSublayer(gradientLayer, at: 0)
}
