//
//  PaddedLabel.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit
import SnapKit
import Then
import Combine

class SkillLabel: UILabel {
    var cancelBag = Set<AnyCancellable>()
    
    var inset: CGSize = CGSize(width: 0, height: 0)
    
    var padding: UIEdgeInsets {
        var hasText: Bool = false
        if let t = text?.count, t > 0 {
            hasText = true
        } else if let t = attributedText?.length, t > 0 {
            hasText = true
        }
        return hasText ? UIEdgeInsets(top: inset.height + 10,
                                      left: inset.width + 10,
                                      bottom: inset.height + 10,
                                      right: inset.width + 35) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    var deleteButton = UIButton().setImageButton(UIImage(systemName: "x.circle"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        backgroundColor = getUIColor(hex: Colors.skillLabelBlue.rawValue)
        layer.cornerRadius = 20
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        font = UIFont.systemFont(ofSize: 14)
        isUserInteractionEnabled = true
        textColor = .white
        
        addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
    }
    
    func onDeletePressed(_ onPressed: (() -> Void)? ) {
        deleteButton.publisher(for: .touchUpInside).sink(receiveValue: { _ in
            onPressed?()
        }).store(in: &cancelBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let superContentSize = super.intrinsicContentSize
        let p = padding
        let width = superContentSize.width + p.left + p.right
        let height = superContentSize.height + p.top + p.bottom
        return CGSize(width: width, height: height)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSizeThatFits = super.sizeThatFits(size)
        let p = padding
        let width = superSizeThatFits.width + p.left + p.right
        let height = superSizeThatFits.height + p.top + p.bottom
        return CGSize(width: width, height: height)
    }
}
