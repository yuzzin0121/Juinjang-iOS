//
//  RecentUpdatedDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct TotalListDto: Codable {
    var limjangList: [ListDto]
}

struct RecentUpdatedDto: Codable {
    let recentUpdatedList: [LimjangDto]
}

struct MainImjangDto: Codable {
    let limjangId: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?
    let address: String
}

struct ListDto: Codable {
    let limjangId: Int
    let images: [String]
    let purposeCode: Int        // 거래목적
    var isScraped: Bool
    let nickname: String
    let priceType: Int
    let priceList: [String]
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String
}

struct LimjangDto: Codable {
    let limjangId: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String
}
