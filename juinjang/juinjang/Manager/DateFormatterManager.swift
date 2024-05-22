//
//  DateFormatterManager.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

final class DateFormatterManager {
    static let shared = DateFormatterManager()
    let dateFormatter = DateFormatter()
    
    private init() { }
    
    func convertEndTime(endTime: Date) -> String {
        dateFormatter.dateFormat = "HH:mm"
        let endTimeString = dateFormatter.string(from: endTime)
        return endTimeString
    }
}
