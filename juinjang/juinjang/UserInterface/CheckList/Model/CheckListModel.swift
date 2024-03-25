//
//  CheckListModel.swift
//  juinjang
//
//  Created by 임수진 on 3/24/24.
//

import Foundation
import RealmSwift

class Property: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var nickname: String = ""
    @objc dynamic var version: Int = 0
    let checklists = List<ChecklistCategory>()
    
    func addChecklist(category: ChecklistCategory) {
        try! realm?.write {
            checklists.append(category)
        }
    }
}

class ChecklistCategory: Object {
    @objc dynamic var name: String = ""
    let items = List<ChecklistItem>()
}

class ChecklistItem: Object {
    @objc dynamic var content: String = ""
    @objc dynamic var type: String = ""
    let options = List<Option>() // 선택형 질문인 경우 옵션 가짐
}

class Option: Object {
    @objc dynamic var option: String = ""
}
