//
//  CheckListItem.swift
//  juinjang
//
//  Created by 임수진 on 1/19/24.
//

import Foundation
import UIKit

struct Category {
    var image: UIImage
    var name: String
    var items: [Item] // Item은 CalendarItem 또는 ScoreItem 등의 공통 프로토콜이라고 가정합니다.
    var isExpanded: Bool = false

    init(image: UIImage, name: String, items: [Item]) {
        self.image = image
        self.name = name
        self.items = items
    }
}

protocol Item {
    // 공통 프로퍼티 또는 메서드 정의
}

struct CalendarItem: Item {
    var title: String
    // CalendarItem에 대한 추가 프로퍼티 또는 메서드 정의
}

struct ScoreItem: Item {
    var content: String
    // ScoreItem에 대한 추가 프로퍼티 또는 메서드 정의
}
