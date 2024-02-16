//
//  CheckListResponseDto.swift
//  juinjang
//
//  Created by 임수진 on 2/15/24.
//

struct CheckListResponseDto: Codable {
    let category: Int
    let questionDtos: [QuestionDto]
}

struct QuestionDto: Codable {
    let questionId: Int
    let category: Int
    let subCategory: String
    let question: String
    let version: Int
    let answerType: Int
    let options: [OptionItems]
    let answer: String
}

struct OptionItems: Codable {
    let indexNum: Int
    let questionId: Int
    let optionValue: String
}
