//
//  UIView+Extension.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit

extension UIView {
    func addGradient(leftColor: UIColor, rightColor: UIColor) {
        let gradient: CAGradientLayer = CAGradientLayer()

        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame.size = frame.size

        layer.insertSublayer(gradient, at: 0)
    }
}
