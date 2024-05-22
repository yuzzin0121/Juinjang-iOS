//
//  Int+Extension.swift
//  juinjang
//
//  Created by 조유진 on 5/21/24.
//

import Foundation

extension Int {
    static func convertTimeToInt(time: TimeInterval) -> Int? {
        let min = Int(time/60)
        let sec = Int(time.truncatingRemainder(dividingBy: 60))
        print(#function, min, sec)
        let strTime = String(format: "%01d%02d", min, sec)
        guard let timeInt = Int(strTime) else {
            return nil
        }
        print(#function, timeInt)
        return timeInt
    }
}
