//
//  String+Extension.swift
//  juinjang
//
//  Created by 조유진 on 2/11/24.
//

import Foundation

extension String {
    // 숫자를 가격으로 바꾸기
    func formatToKoreanCurrencyWithZero() -> String {
        guard let price = Int(self) else { return self }
        let billion = price / 100_000_000 // 억 단위
        let million = (price % 100_000_000) / 10_000 // 만 단위
        let remainder = price % 10_000 // 원 단위

        var parts: [String] = []

        if billion > 0 {
            parts.append("\(billion)억")
        }
        if million > 0 || (billion > 0 && million == 0) {
            // "억" 단위가 있고 "만" 단위가 0일 경우 "0만"을 추가
            parts.append("\(million)천만")
        }
        if remainder > 0 || (parts.isEmpty && remainder == 0) {
            // "억" 또는 "만" 단위가 없고 "원" 단위만 있는 경우 또는 전부 0인 경우
            parts.append("\(remainder)원")
        } else if !parts.isEmpty && remainder == 0 {
            // "억" 또는 "만" 단위가 있고 "원" 단위가 0일 경우 "원"만 추가
            parts.append("원")
        }

        return parts.joined(separator: " ")
    }
    
    static func dateToString(target: String) -> String {
        // 서버에서 주는 형태 (ISO규약에 따른 문자열 형태)
        guard let isoDate = ISO8601DateFormatter().date(from: target ?? "") else {
            return ""
        }
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = myFormatter.string(from: isoDate)
        return dateString
    }
}
