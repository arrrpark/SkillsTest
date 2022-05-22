//
//  AppbaseViewController.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit
import Then
import SnapKit

class AppbaseViewController: UIViewController {
    
    lazy var activityIndicator = UIActivityIndicatorView().then {
        $0.startAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = getUIColor(hex: Colors.darkGray.rawValue)
        
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        
    }
    
    func setupConstraints() {
        
    }
}

