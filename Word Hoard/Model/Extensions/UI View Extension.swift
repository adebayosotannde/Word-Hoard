//
//  UI View Extension.swift
//  Learner
//
//  Created by Adebayo Sotannde on 10/31/22.
//

import UIKit

extension UIView
{
    @IBInspectable var cornerRadius: CGFloat
    {
        get
        {
            return self.cornerRadius
            
        }
        set
        {
            self.layer.cornerRadius = newValue
        }
    }
}
