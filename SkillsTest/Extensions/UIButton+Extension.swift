//
//  UIButton+Extension.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit

extension UIButton {
    @discardableResult
    func setImageButton(_ image: UIImage?) -> UIButton {
        setImage(image, for: .normal)
        tintColor = .white
        imageView?.contentMode = .scaleAspectFit
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        return self
    }
}
