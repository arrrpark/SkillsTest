//
//  MajorCell.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit
import SnapKit
import Then

class AreaCell: UICollectionViewCell {
    lazy var majorLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.textColor = .white
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
        addSubview(majorLabel)
    }
    
    private func setupConstraints() {
        majorLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(60)
            make.centerY.equalToSuperview()
        }
    }
}
