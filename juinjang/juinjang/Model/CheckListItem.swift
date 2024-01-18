//
//  CheckListItem.swift
//  juinjang
//
//  Created by 임수진 on 1/19/24.
//

import Foundation
import UIKit

struct Category {
    let image: UIImage
    let name: String
    var items: [CheckListItem]
}

struct CheckListItem {
    let content: String
    let score: Int
}
