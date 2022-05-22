//
//  AddSkillsViewController.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit
import Then
import SnapKit
import Combine

protocol OnAddSkillPressed: AnyObject {
    func onAddSkillPressed()
}

class AddSkillsViewController: AppbaseViewController {
    weak var onAddSkillPressed: OnAddSkillPressed?
    
    var cancelBag = Set<AnyCancellable>()
    
    let skillsPickViewModel: SkillsPickViewModel
    
    lazy var containerView = UIView().then {
        $0.backgroundColor = getUIColor(hex: Colors.lightGray.rawValue)
    }
    
    lazy var grabView = UIView().then {
        $0.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(transitionGesture(_:))))
    }
    
    lazy var grabImageView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = moderateScale(5)
    }
    
    lazy var searchGuideLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "Add skills"
        $0.font = UIFont.systemFont(ofSize: moderateScale(20))
    }
    
    lazy var searchContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
        $0.layer.cornerRadius = moderateScale(20)
    }
    
    lazy var skillsIconView = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .black
    }
    
    lazy var searchTextField = UITextField().then {
        $0.attributedPlaceholder = NSAttributedString(string: "Search skills", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        $0.textColor = .black
        $0.addTarget(self, action: #selector(searchWordDidChange(textField:)), for: .editingChanged)
    }
    
    lazy var skillsCollectionFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }

    lazy var skillsCollectionView = SkillsCollectionView(frame: .zero, collectionViewLayout: skillsCollectionFlowLayout, skillsPickViewModel: skillsPickViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    lazy var addSkillsButton = UIButton().then {
        $0.backgroundColor = .orange
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Add Skills", for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
        $0.publisher(for: .touchUpInside).sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            
            guard self.skillsPickViewModel.selectedSkils.count >= 5 else {
                self.showAlert("You should select at least 5 skills.")
                return
            }
            
            guard self.skillsPickViewModel.selectedSkils.count <= 20 else {
                self.showAlert("You can select 20 skills at most.")
                return
            }
            
            self.onAddSkillPressed?.onAddSkillPressed()
            self.dismiss(animated: false)
        }).store(in: &cancelBag)
    }
    
    var containerViewHeightConstraint: Constraint?
    let initialContainerViewHeightConstant = UIScreen.main.bounds.height - getSafeAreaTopBottom().top - verticalScale(50)
    
    init(skillsPickViewModel: SkillsPickViewModel) {
        self.skillsPickViewModel = skillsPickViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        showIndicator()
        skillsPickViewModel.searchSkills().sink(receiveCompletion: { [weak self] _ in
            self?.hideIndicator()
        }, receiveValue: { [weak self] skills in
            self?.skillsPickViewModel.skills = skills
            self?.skillsPickViewModel.searchedSkills.send(skills)
            self?.skillsCollectionView.reloadData()
        }).store(in: &cancelBag)
        
        skillsPickViewModel.searchedSkills.sink(receiveValue: { [weak self] _ in
            self?.skillsCollectionView.reloadData()
        }).store(in: &cancelBag)
        
        view.layoutIfNeeded()
        addSkillsButton.addGradient(leftColor: getUIColor(hex: Colors.gradationLeftOrange.rawValue), rightColor: getUIColor(hex: Colors.gradationRightOrange.rawValue))
    }
    
    override func setupViews() {
        view.addSubview(containerView)
        
        containerView.addSubview(grabView)
        grabView.addSubview(grabImageView)
        
        containerView.addSubview(searchGuideLabel)
        containerView.addSubview(searchContainerView)
        searchContainerView.addSubview(skillsIconView)
        searchContainerView.addSubview(searchTextField)
        containerView.addSubview(skillsCollectionView)
        containerView.addSubview(addSkillsButton)
    }
    
    override func setupConstraints() {
        containerView.snp.makeConstraints { make in
            containerViewHeightConstraint = make.height.equalTo(initialContainerViewHeightConstant).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        grabView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(verticalScale(30))
        }
        
        grabImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(verticalScale(10))
            make.width.equalTo(horizontalScale(40))
            make.height.equalTo(verticalScale(5))
            make.centerX.equalToSuperview()
        }
        
        searchGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(grabView.snp.bottom)
            make.centerX.equalToSuperview()
        }
        
        searchContainerView.snp.makeConstraints { make in
            make.top.equalTo(searchGuideLabel.snp.bottom).offset(verticalScale(10))
            make.leading.equalToSuperview().offset(horizontalScale(20))
            make.trailing.equalToSuperview().offset(-horizontalScale(20))
            make.height.equalTo(verticalScale(50))
        }
        
        skillsIconView.snp.makeConstraints { make in
            make.size.equalTo(moderateScale(20))
            make.leading.equalToSuperview().offset(horizontalScale(horizontalScale(15)))
            make.centerY.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(skillsIconView.snp.trailing).offset(horizontalScale(10))
            make.trailing.equalToSuperview().offset(-horizontalScale(10))
        }
        
        skillsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchContainerView.snp.bottom).offset(verticalScale(20))
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(addSkillsButton.snp.top).offset(-verticalScale(10))
        }
        
        addSkillsButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(searchContainerView)
            make.bottom.equalToSuperview().offset(-getSafeAreaTopBottom().bottom - verticalScale(20))
            make.height.equalTo(verticalScale(50))
        }
    }
    
    @objc func searchWordDidChange(textField: UITextField) {
        guard let text = textField.text, text != "" else {
            skillsPickViewModel.searchedSkills.send(skillsPickViewModel.skills)
            return
        }
        
        skillsPickViewModel.searchSkillsLocally(text)
    }
    
    @objc func transitionGesture(_ sender: UIPanGestureRecognizer) {
        guard let containerViewHeightConstraint = containerViewHeightConstraint else {
            return
        }

        let location = sender.location(in: view)
        
        switch sender.state {
        case .ended:
            if containerViewHeightConstraint.layoutConstraints[0].constant > UIScreen.main.bounds.height * 2 / 3 {
                containerViewHeightConstraint.update(offset: initialContainerViewHeightConstant)
            } else {
                hideSelector()
            }
        case .changed:
            if location.y < UIScreen.main.bounds.height / 2, location.y > getSafeAreaTopBottom().top + 20 {
                containerViewHeightConstraint.update(offset: UIScreen.main.bounds.height - location.y)
            } else {
                sender.state = .ended
            }
        default:
            break
        }
    }
    
    func hideSelector() {
        skillsPickViewModel.selectedSkils.removeAll()
        dismiss(animated: false)
    }
}

extension AddSkillsViewController: SkillsCollectionViewDelegate {
    func skillsCollectionView(_ collectionView: SkillsCollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let name = skillsPickViewModel.searchedSkills.value[indexPath.item].name else { return }
        
        skillsPickViewModel.selectSkill(name)
        collectionView.reloadItems(at: [indexPath])
    }
}
