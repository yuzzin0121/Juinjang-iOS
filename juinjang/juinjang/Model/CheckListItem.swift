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
    var isExpanded: Bool

    init(image: UIImage, name: String, items: [Item]) {
        self.image = image
        self.name = name
        self.items = items
        self.isExpanded = false
    }
}

protocol Item {
    var content: String { get }
}

struct CalendarItem: Item {
    var content: String
    var inputDate: Date?
}

struct ScoreItem: Item {
    var content: String
    var score: Int?
    
    init(content: String) {
        self.content = content
    }
}

struct InputItem: Item {
    var content: String
    var inputAnswer: String?
}

struct SelectionItem: Item {
    var content: String
    var options: [String]
    var selectAnswer: String?
}

protocol DataUpdateDelegate: AnyObject {
    func getItem(at indexPath: IndexPath) -> Item
    func updateItem(item: Item, at indexPath: IndexPath)
}
