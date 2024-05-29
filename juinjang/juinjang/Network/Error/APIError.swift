//
//  APIError.swift
//  juinjang
//
//  Created by 조유진 on 5/29/24.
//

import Foundation

enum APIError: Int, Error, LocalizedError {
    case accessTokenExpired = 419
    case refreshTokenExpired = 418
    
    var errorDescription: String? {
        switch self {
        case .accessTokenExpired:
            return "액세스 토큰이 만료되었습니다. 토큰을 갱신해주세요."
        case .refreshTokenExpired:
            return "로그인이 필요합니다."
        }
    }
}
