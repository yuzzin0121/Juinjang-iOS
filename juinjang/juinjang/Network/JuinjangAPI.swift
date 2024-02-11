//
//  JuinjangAPI.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
import Alamofire

enum JuinjangAPI {
    case kakaoLogin
    case kakaoLoginCallback
    case regenerateToken
    case logout
    
    case nickname
    case profile
    
    case scrap(imjangId: Int)
    case totalImjang
    case createImjang
    case modifyImjang
    case searchImjang(keyword: String)
    case mainImjang
    case detailImjang(imjangId: Int)
    case deleteImjangs(imjangId: [Int])
    
    var baseURL: String {
        return "http://juinjang1227.com:8080/api/"
    }
    
    var endpoint: URL {
        switch self {
        case .kakaoLogin:
            return URL(string: baseURL + "auth/kakao")!
        case .kakaoLoginCallback:
            return URL(string: baseURL + "auth/kakao/callback")!
        case .regenerateToken:
            return URL(string: baseURL + "auth/regenerate-token")!
        case .logout:
            return URL(string: baseURL + "logout")!
            
        case .nickname:
            return URL(string: baseURL + "nickname")!
        case .profile:
            return URL(string: baseURL + "profile")!
            
        case .scrap(let imjangId):
            return URL(string: baseURL + "scrap/\(imjangId)")!
        case .totalImjang, .createImjang, .modifyImjang:
            return URL(string: baseURL + "limjang")!
            
        case .searchImjang(let keyword):
            return URL(string: baseURL + "limjang/\(keyword)")!
            
        case .mainImjang:
            return URL(string: baseURL + "limjang/main")!
        case .detailImjang(let imjangId):
            return URL(string: baseURL + "limjang/detail/\(imjangId)")!
        case .deleteImjangs(let imjangIds):
            return URL(string: baseURL + "limjang/\(imjangIds)")!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .kakaoLogin, .regenerateToken, .detailImjang, .totalImjang, .scrap, .searchImjang:
            return ["Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"]

        default:
            return [:]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .scrap, .createImjang, .regenerateToken, .logout:
            return .post
        case .totalImjang, .searchImjang, .mainImjang, .detailImjang, .kakaoLogin, .kakaoLoginCallback, .profile:
            return .get
        case .nickname, .modifyImjang:
            return .patch
        case .deleteImjangs:
            return .delete
        }
    }
    
    var parameter: Parameters {
        switch self {
        case .detailImjang(let imjangId):
            [:]
        default:
            [:]
        }
    }
}
