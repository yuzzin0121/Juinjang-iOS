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
    var items: [Item] // 공통 프로토콜
    var isExpanded: Bool = false

    init(image: UIImage, name: String, items: [Item]) {
        self.image = image
        self.name = name
        self.items = items
    }
}

protocol Item {
}

struct CalendarItem: Item {
    var content: String
    var inputDate: Date?
}

struct ScoreItem: Item {
    var content: String
    var score: Int?
}

struct InputItem: Item {
    var content: String
    var inputAnswer: String?
}

struct SelectionItem: Item {
    var content: String
    var inputAnswer: String?
}
