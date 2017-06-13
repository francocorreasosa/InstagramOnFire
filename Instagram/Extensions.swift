//
//  Extensions.swift
//  Instagram
//
//  Created by Franco Correa on 6/11/17.
//  Copyright © 2017 Franco Correa. All rights reserved.
//

import UIKit

extension UIViewController {
    func simpleAlert(title: String, message: String, buttonTitle: String = "OK") {
        // Create alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Create and append action
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(action)
        
        // Present into View Controller
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIColor {
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1)
    }
}

extension UIView {
    func addConstraints(visualFormat: String, views: UIView...) {
        var viewGroup = [String: UIView]()
        
        for (idx, view) in views.enumerated() {
            viewGroup["v\(idx)"] = view
        }
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: NSLayoutFormatOptions(), metrics: nil, views: viewGroup))
    }
    
    func anchor(top: NSLayoutYAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                left: NSLayoutXAxisAnchor?,
                right: NSLayoutXAxisAnchor?,
                paddingTop: CGFloat,
                paddingBottom: CGFloat,
                paddingLeft: CGFloat,
                paddingRight: CGFloat,
                width: CGFloat,
                height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
                
                
}
