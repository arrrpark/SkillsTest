//
//  ViewController.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import UIKit
import Then
import SnapKit
import Combine

class SkillsPickViewController: AppbaseViewController {
    var cancelBag = Set<AnyCancellable>()
    
    let skillsPickViewModel: SkillsPickViewModel
    
    lazy var areaPickerView = UIView().then {
        $0.backgroundColor = getUIColor(hex: Colors.darkGray.rawValue)
    }
    
    lazy var areaGuideLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "Choose your area"
        $0.font = UIFont.boldSystemFont(ofSize: horizontalScale(20))
    }
    
    lazy var areaBorderView = UIView().then {
        $0.backgroundColor = .white
    }
    
    lazy var areaCollectionViewFLowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 0
        $0.minimumInteritemSpacing = 0
    }
    
    lazy var areaCollectionView = AreaCollectionView(frame: .zero, collectionViewLayout: areaCollectionViewFLowLayout, skillsPickViewModel: skillsPickViewModel).then {
        $0.backgroundColor = .clear
        $0.viewDelegate = self
    }
    
    lazy var optionBar = UIView()
    
    lazy var backButton = UIButton().setImageButton(UIImage(systemName: "arrow.left"))
    
    lazy var skillPickGuideLabel = UILabel().then {
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    lazy var selectedSkillsScrollView = UIScrollView().then {
        $0.addSubview(selectedSkillsContentView)
    }
    
    lazy var selectedSkillsContentView = UIView()
    
    lazy var addSkillsButton = UIButton().then {
        $0.setTitleColor(.orange, for: .normal)
        $0.setTitle("+ Add more skills", for: .normal)
        
        $0.publisher(for: .touchUpInside).sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            
            let viewController = AddSkillsViewController(skillsPickViewModel: self.skillsPickViewModel)
            viewController.modalPresentationStyle = .overCurrentContext
            viewController.onAddSkillPressed = self
            self.present(viewController, animated: false)
        }).store(in: &cancelBag)
    }
    
    lazy var matchingLabel = UILabel().then {
        let attributedString = NSMutableAttributedString(string: "You're matching ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.white])
        let roles = NSMutableAttributedString(string: "172 Roles ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : getUIColor(hex: Colors.skyBlue.rawValue)])
        let suffixString = NSMutableAttributedString(string: "on Caroo", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.white])
        attributedString.append(roles)
        attributedString.append(suffixString)
        
        $0.textAlignment = .center
        $0.attributedText = attributedString
    }
    
    lazy var confirmSkillsButton = UIButton().then {
        $0.clipsToBounds = true
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("Confirm My Skills", for: .normal)
        $0.layer.cornerRadius = 20
    }
    
    init(skillsPickViewModel: SkillsPickViewModel) {
        self.skillsPickViewModel = skillsPickViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showIndicator()
        skillsPickViewModel.searchMajors().sink(receiveCompletion: { [weak self] _ in
            self?.hideIndicator()
        }, receiveValue: { [weak self] majors in
            self?.skillsPickViewModel.majors = majors
            self?.areaCollectionView.reloadData()
        }).store(in: &cancelBag)
        
        skillsPickViewModel.area.sink(receiveValue: { [weak self] area in
            let attributedString = NSMutableAttributedString(string: "As a ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
            
            let areaString = NSMutableAttributedString(string: "\(area) Developer", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)])
            
            let suffixString = NSMutableAttributedString(string: " we think you might have the following skills :", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)])
            
            attributedString.append(areaString)
            attributedString.append(suffixString)
            self?.skillPickGuideLabel.attributedText = attributedString
        }).store(in: &cancelBag)
        
        addSelectedSkills()
        view.layoutIfNeeded()
        confirmSkillsButton.addGradient(leftColor: getUIColor(hex: Colors.gradationLeftOrange.rawValue), rightColor: getUIColor(hex: Colors.gradationRightOrange.rawValue))
    }
    
    override func setupViews() {
        view.addSubview(optionBar)
        optionBar.addSubview(backButton)
        
        view.addSubview(skillPickGuideLabel)
        view.addSubview(selectedSkillsScrollView)
        view.addSubview(addSkillsButton)
        view.addSubview(matchingLabel)
        view.addSubview(confirmSkillsButton)
        
        view.addSubview(areaPickerView)
        areaPickerView.addSubview(areaGuideLabel)
        areaPickerView.addSubview(areaBorderView)
        areaPickerView.addSubview(areaCollectionView)
    }
    
    override func setupConstraints() {
        areaPickerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        areaGuideLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(getSafeAreaTopBottom().top + verticalScale(10))
            make.leading.equalToSuperview().offset(horizontalScale(20))
            make.trailing.equalToSuperview().offset(-horizontalScale(20))
            make.height.equalTo(verticalScale(40))
        }
        
        areaBorderView.snp.makeConstraints { make in
            make.top.equalTo(areaGuideLabel.snp.bottom)
            make.leading.trailing.equalTo(areaGuideLabel)
            make.height.equalTo(1)
        }
        
        areaCollectionView.snp.makeConstraints { make in
            make.top.equalTo(areaGuideLabel.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        optionBar.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(getSafeAreaTopBottom().top + 10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(verticalScale(30))
        }
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(horizontalScale(20))
            make.size.equalTo(moderateScale(25))
            make.centerY.equalToSuperview()
        }
        
        skillPickGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(optionBar.snp.bottom).offset(verticalScale(10))
            make.leading.equalToSuperview().offset(horizontalScale(20))
            make.trailing.equalToSuperview().offset(-horizontalScale(20))
        }
        
        selectedSkillsScrollView.snp.makeConstraints { make in
            make.top.equalTo(skillPickGuideLabel.snp.bottom).offset(verticalScale(20))
            make.leading.trailing.equalTo(skillPickGuideLabel)
            make.height.equalTo(verticalScale(300))
        }
        
        selectedSkillsContentView.snp.makeConstraints { make in
            make.top.leading.width.equalToSuperview()
            make.height.equalTo(0)
            make.bottom.equalToSuperview()
        }
        
        addSkillsButton.snp.makeConstraints { make in
            make.top.equalTo(selectedSkillsScrollView.snp.bottom).offset(verticalScale(20))
            make.width.equalTo(horizontalScale(200))
            make.height.equalTo(verticalScale(40))
            make.centerX.equalToSuperview()
        }
        
        matchingLabel.snp.makeConstraints { make in
            make.leading.trailing.equalTo(skillPickGuideLabel)
            make.bottom.equalTo(confirmSkillsButton.snp.top).offset(-verticalScale(20))
        }
        
        confirmSkillsButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(skillPickGuideLabel)
            make.bottom.equalToSuperview().offset(-getSafeAreaTopBottom().bottom - verticalScale(20))
            make.height.equalTo(verticalScale(50))
        }
    }
    
    private func addSelectedSkills() {
        selectedSkillsContentView.subviews.forEach { $0.removeFromSuperview() }
        
        let skills = Array(skillsPickViewModel.selectedSkils).sorted(by: <)
        let totalWidth = UIScreen.main.bounds.width - 40
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 10
        
        skills.forEach { skill in
            let paddedLabel = SkillLabel().then {
                $0.text = skill
                $0.onDeletePressed({ [weak self] in
                    guard let self = self else { return }
                    
                    guard self.skillsPickViewModel.selectedSkils.count > 5 else {
                        self.showAlert("You should select at least 5 skills.")
                        return
                    }
                    
                    self.skillsPickViewModel.selectedSkils.remove(skill)
                    self.addSelectedSkills()
                })
            }
            
            let labelWidth = paddedLabel.intrinsicContentSize.width
            let labelHeight = paddedLabel.intrinsicContentSize.height
            
            if offsetX + labelWidth < totalWidth {
                selectedSkillsContentView.addSubview(paddedLabel)
                
                paddedLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(offsetY)
                    make.leading.equalToSuperview().offset(offsetX)
                }
                
                offsetX += labelWidth + 10
            } else {
                offsetX = 0
                offsetY += labelHeight + 10
                selectedSkillsContentView.addSubview(paddedLabel)
                
                paddedLabel.snp.makeConstraints { make in
                    make.top.equalToSuperview().offset(offsetY)
                    make.leading.equalToSuperview().offset(offsetX)
                }
                
                offsetX += labelWidth + 10
            }
        }
        
        let height = offsetY + 50 > verticalScale(300) ? verticalScale(300) : offsetY + 50
        selectedSkillsScrollView.snp.updateConstraints { make in make.height.equalTo(height) }
        selectedSkillsContentView.snp.updateConstraints { make in make.height.equalTo(offsetY + 50)  }
    }
}

extension SkillsPickViewController: AreaCollectionViewDelegate {
    func majorCollectionView(_ collectionView: AreaCollectionView, didSelectItemAt indexPath: IndexPath) {
        skillsPickViewModel.area.send(skillsPickViewModel.majors[indexPath.item].name ?? "")
        areaPickerView.isHidden = true
    }
}

extension SkillsPickViewController: OnAddSkillPressed {
    func onAddSkillPressed() {
        addSelectedSkills()
    }
}
