//
//  ImagesListDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct ImagesListDto: Decodable {
    let images: [ImageDto]
}

struct ImageDto: Decodable {
    let imageId: Int
    let imageUrl: String
}
