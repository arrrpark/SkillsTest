//
//  SkillCell.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit
import SnapKit
import Then

class SkillCell: UICollectionViewCell {
    
    lazy var skillLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .white
    }
    
    lazy var addImageView = UIImageView().then {
        $0.image = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .white
    }
    
    lazy var underlineView = UIView().then {
        $0.backgroundColor = getUIColor(hex: Colors.orange.rawValue)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(skillLabel)
        addSubview(addImageView)
        addSubview(underlineView)
    }
    
    private func setupConstraints() {
        skillLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        addImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.leading.equalTo(skillLabel)
            make.trailing.equalTo(addImageView)
            make.height.equalTo(1)
            make.bottom.equalToSuperview().offset(-5)
        }
    }
}
