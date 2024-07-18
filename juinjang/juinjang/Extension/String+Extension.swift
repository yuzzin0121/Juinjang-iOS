//
//  String+Extension.swift
//  juinjang
//
//  Created by 조유진 on 2/11/24.
//

import Foundation
import UIKit

extension String {
    
    static func formatSeconds(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
    
    // 숫자를 가격으로 바꾸기
    
    func formatToKoreanCurrencyWithZero() -> String {
        guard let price = Int(self) else { return self }
        // 숫자를 한국 원(KRW) 단위로 변환합니다.
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 세자리마다 콤마를 찍어주는 스타일
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 로케일 설정
        
        // 단위 배열
        let units = ["", "만", "억", "조", "경"]
        var formattedString = ""
        var value = price
        
        // 단위별로 숫자를 나누어 변환합니다.
        for unit in units {
            let rem = value % 10000
            if rem > 0 {
                if let formattedRem = formatter.string(from: NSNumber(value: rem)) {
                    formattedString = formattedRem + unit + " " + formattedString
                }
            }
            value /= 10000
            if value == 0 {
                break
            }
        }
        
        return formattedString.trimmingCharacters(in: .whitespaces) + "원"
    }
    
    static func dateToString(target: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        guard let isoDate = dateFormatter.date(from: target) else {
            return ""
        }
//        let myFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        let dateString = dateFormatter.string(from: isoDate)
        return dateString
    }
    
    func twoSplitAmount() -> (String, String) {
        // 문자열을 숫자로 변환
        if let amount = Int(self) {
            let units = amount / 100000000
            let remainder = (amount % 100000000) / 10000

            // 나눈 결과를 문자열로 변환하여 반환
            return (String(units), String(remainder))
        } else {
            // 변환 실패 시 기본값 반환
            return ("0", "0")
        }
    }
    
    func oneSplitAmount() -> String {
        // 문자열을 숫자로 변환
        if let amount = Int(self) {
            let remainder = (amount % 100000000) / 10000

            // 문자열로 변환하여 반환
            return String(remainder)
        } else {
            // 변환 실패 시 기본값 반환
            return ("0")
        }
    }
    
    // 텍스트 너비 계산
    func size(forFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return (self as NSString).size(withAttributes: fontAttributes)
    }
    
    func width(forFont font: UIFont) -> CGFloat {
        return self.size(forFont: font).width
    }
}
