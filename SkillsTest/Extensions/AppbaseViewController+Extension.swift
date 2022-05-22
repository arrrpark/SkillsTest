//
//  AppbaseViewController.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit
import Then
import SnapKit

extension AppbaseViewController {
    func showIndicator() {
        guard !view.subviews.contains(activityIndicator) else { return }
        
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func hideIndicator() {
        guard view.subviews.contains(activityIndicator) else { return }
            
        activityIndicator.removeFromSuperview()
    }
    
    func showAlert(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: false, completion: nil)
    }
}
