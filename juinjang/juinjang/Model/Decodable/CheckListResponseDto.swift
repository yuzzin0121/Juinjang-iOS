//
//  CheckListResponseDto.swift
//  juinjang
//
//  Created by 임수진 on 2/15/24.
//

struct CheckListResponseDto: Decodable {
    let category: Int
    let questionDtos: [QuestionDto]
}

struct QuestionDto: Decodable {
    let questionId: Int
    let category: Int
    let subCategory: String
    let question: String
    let version: Int
    let answerType: Int
    let options: [OptionItem]
}

struct OptionItem: Decodable {
    let indexNum: Int
    let questionId: Int
    let optionValue: String
}
