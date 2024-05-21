//
//  RecordResponseDTO.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

struct RecordResponseDTO: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: RecordResponse?
}

struct RecordResponse: Codable {
    let recordName: String
    let createdAt: String
    let updatedAt: String
    let recordScript: String
    let recordTime: Int
    let recordUrl: String
    let recordId: Int
    let limjangId: Int
}
