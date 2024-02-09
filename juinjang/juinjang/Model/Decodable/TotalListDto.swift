//
//  RecentUpdatedDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct TotalListDto: Decodable {
    var scrapedList: [ListDto]
    var notScrapedList: [ListDto]
}

struct RecentUpdatedDto: Decodable {
    let recentUpdatedList: [ListDto]
}

struct ListDto: Decodable {
    let limjangId: Int
    let images: [String]
    let purposeCode: Int        // 거래목적
    let isScraped: Bool
    let nickname: String
    let priceType: Int
    let priceList: [String]
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String
    let createAt: String
    let updatedAt: String
}
