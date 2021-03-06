//
//  MaterialView.swift
//  DreamLister
//
//  Created by Jeet Parte on 27/06/17.
//  Copyright © 2017 Jeet Parte. All rights reserved.
//

import UIKit

private var materialKey = false
extension UIView {
    @IBInspectable var materiaDesign: Bool {
        get {
            return materialKey
        } set {
            materialKey = newValue
            if materialKey {
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 157/255).cgColor
            } else {
                self.layer.cornerRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: -3.0)
                self.layer.shadowColor = UIColor.black.cgColor
            }
        }
    }
}
