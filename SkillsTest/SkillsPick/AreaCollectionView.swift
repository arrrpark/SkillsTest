//
//  MajorCollectionView.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit

protocol AreaCollectionViewDelegate: AnyObject {
    func majorCollectionView(_ collectionView: AreaCollectionView, didSelectItemAt indexPath: IndexPath)
}

class AreaCollectionView: UICollectionView {
    weak var viewDelegate: AreaCollectionViewDelegate?

    let skillsPickViewModel: SkillsPickViewModel

    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, skillsPickViewModel: SkillsPickViewModel) {
        self.skillsPickViewModel = skillsPickViewModel
        super.init(frame: frame, collectionViewLayout: layout)

        register(AreaCell.self, forCellWithReuseIdentifier: String(describing: AreaCell.self))
        
        delegate = self
        dataSource = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AreaCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewDelegate?.majorCollectionView(self, didSelectItemAt: indexPath)
    }
}

extension AreaCollectionView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return skillsPickViewModel.majors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: AreaCell.self), for: indexPath) as? AreaCell else {
            return UICollectionViewCell()
        }
        
        cell.majorLabel.text = skillsPickViewModel.majors[indexPath.row].name
        return cell
    }
}

extension AreaCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
}

