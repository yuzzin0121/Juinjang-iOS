//
//  ReportDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct ReportDto: Decodable {
    let reportId: Int
    let indoorKeyword: String
    let publicSpaceKeyWord: String
    let locationCoditionWord: String
    let indoorRate: Float
    let publicSpaceRate: Float
    let locationCoditionsRate: Float
    let totalRate: Float
}


