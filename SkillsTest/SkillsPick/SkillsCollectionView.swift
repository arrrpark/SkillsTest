//
//  SkillsCollectionView.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit

protocol SkillsCollectionViewDelegate: AnyObject {
    func skillsCollectionView(_ collectionView: SkillsCollectionView, didSelectItemAt indexPath: IndexPath)
}

class SkillsCollectionView: UICollectionView {
    weak var viewDelegate: SkillsCollectionViewDelegate?

    let skillsPickViewModel: SkillsPickViewModel

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, skillsPickViewModel: SkillsPickViewModel) {
        self.skillsPickViewModel = skillsPickViewModel
        super.init(frame: frame, collectionViewLayout: layout)

        register(SkillCell.self, forCellWithReuseIdentifier: String(describing: SkillCell.self))
        
        delegate = self
        dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SkillsCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.skillsCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension SkillsCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skillsPickViewModel.searchedSkills.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: SkillCell.self), for: indexPath) as? SkillCell else {
            return UICollectionViewCell()
        }
        
        let data = skillsPickViewModel.searchedSkills.value[indexPath.row]
        let clicked = skillsPickViewModel.selectedSkils.contains(data.name ?? "")
        
        cell.underlineView.isHidden = !clicked
        cell.addImageView.image = clicked
        ? UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        : UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
        cell.addImageView.tintColor = clicked ? getUIColor(hex: Colors.orange.rawValue) : .white
        cell.skillLabel.font = clicked ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 14)
        cell.skillLabel.text = data.name
        
        return cell
    }
}

extension SkillsCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
}

