//
//  SkillsPickViewModel.swift
//  SkillsTest
//
//  Created by Arrr Park on 22/05/2022.
//

import Foundation
import Combine
import Alamofire

class SkillsPickViewModel {
    var area = CurrentValueSubject<String, Never>("")
    var majors: [Skill] = []
    
    var skills: [Skill] = []
    var searchedSkills = CurrentValueSubject<[Skill], Never>([])
    var selectedSkils = Set<String>()

    func searchMajors() -> Future<[Skill], NetworkError> {
        return AlamofireWrapper.shared.byGet(url: "suggested-skills.json")
    }
    
    func searchSkills() -> Future<[Skill], NetworkError> {
        return AlamofireWrapper.shared.byGet(url: "skills.json")
    }
    
    func searchSkillsLocally(_ word: String) {
        let result = skills.filter{ $0.name != nil }.filter { $0.name!.contains(word) }
        searchedSkills.send(result)
    }
    
    func selectSkill(_ skill: String) {
        if selectedSkils.contains(skill) {
            selectedSkils.remove(skill)
        } else {
            selectedSkils.insert(skill)
        }
    }
}
