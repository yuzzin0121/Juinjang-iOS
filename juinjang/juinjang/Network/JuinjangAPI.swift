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
    
    case checklist
//    case checklist(imjangId: Int)
    
    case scrap(imjangId: Int)
    case totalImjang
    case createImjang
    case modifyImjang
    case searchImjang(keyword: String)
    case mainImjang
    case detailImjang(imjangId: Int)
    case deleteImjangs(imjangIds: [Int])
    
    case memo(imjangId: Int)
    case fetchRecordingRoom(imjangId: Int)
    
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
            
        case .checklist:
            return URL(string: baseURL + "checklist")!
//        case .checklist(let imjangId):
//            return URL(string: baseURL + "checklist/\(imjangId)")!
            
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
        case .deleteImjangs:
            return URL(string: baseURL + "limjang/delete")!
        case .memo(let imjangId):
            return URL(string: baseURL + "memo/\(imjangId)")!
        case .fetchRecordingRoom(let imjangId):
            return URL(string: baseURL + "record/\(imjangId)")!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .kakaoLogin, .regenerateToken, .checklist, .detailImjang, .totalImjang, .scrap, .searchImjang, .deleteImjangs, .memo, .fetchRecordingRoom:
            return ["Content-Type": "application/json", "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"]

        default:
            return ["Content-Type": "application/json", "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .checklist, .scrap, .createImjang, .regenerateToken, .logout, .deleteImjangs, .memo:
            return .post
        case .checklist, .totalImjang, .searchImjang, .mainImjang, .detailImjang, .kakaoLogin, .kakaoLoginCallback, .profile, .fetchRecordingRoom:
            return .get
        case .nickname, .modifyImjang:
            return .patch
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .deleteImjangs, .memo:
            return JSONEncoding.default
        default:
            return URLEncoding(destination: .queryString)
        }
    }

    
    var parameter: [String: Any] {
        switch self {
        case .detailImjang(let imjangId):
            return  ["limjangIdList": imjangId]
        default:
            return [:]
        }
    }
}
