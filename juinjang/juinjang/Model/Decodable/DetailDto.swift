//
//  DetailDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
 
struct DetailDto: Decodable {
    let limjangId: Int
    let images: [String]
    let purposeCode: Int
    let nickname: String
    let priceType: Int
    let adderess: String
    let addressDetail: String
    let createdAt: String
    let updated: String
}

struct RecordMemoDto: Decodable {
    let limjangId: Int
    let memo: String
    let createdAt: String
    let updatedAt: String
    let recordDto: [RecordDto]
}

struct RecordDto: Decodable {
    let limjangId: Int
    let recordTime: Int
    let recordScript: String
    let recordUrl: String
    let recordName: String
    let createdAt: String
    let updatedAt: String
}

struct memoDto: Decodable {
    let limjangId: Int
    let createdAt: String
    let updatedAt: String
    let memo: String
}
