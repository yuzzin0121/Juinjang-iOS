//
//  ProfileDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct ProfileDto {
    let nickname: String
    let email: String
    let provider: String
}

struct RefreshDto: Codable {
    let accessToken: String
    let refreshToken: String
    let nickname: String
}
