//
//  UIView+Extension.swift
//  ShareTEE
//
//  Created by MacBook Pro on 26/01/2022.
//
import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return self.cornerRadius }
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
