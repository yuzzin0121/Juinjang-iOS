//
//  AnswerModel.swift
//  juinjang
//
//  Created by 임수진 on 5/12/24.
//

import Foundation
import RealmSwift

class CheckListAnswer: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var imjangId: Int
    @Persisted var questionId: Int
    @Persisted var answer: String
    @Persisted var isSelected: Bool
    
    convenience init(id: ObjectId, imjangId: Int, questionId: Int, answer: String, isSelected: Bool) {
        self.init()
        self.id = id
        self.imjangId = imjangId
        self.questionId = questionId
        self.answer = answer
        self.isSelected = isSelected
    }
}
