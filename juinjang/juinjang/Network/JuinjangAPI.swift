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
    
    case showChecklist(imjangId: Int)
    case saveChecklist(imjangId: Int)
    case modifyChecklist(imjangId: Int)
    
    case scrap(imjangId: Int)
    case totalImjang(sort: String)
    case createImjang
    case modifyImjang
    case searchImjang(keyword: String)
    case mainImjang
    case detailImjang(imjangId: Int)
    case deleteImjangs(imjangIds: [Int])
    
    case memo(imjangId: Int)
    case fetchRecordingRoom(imjangId: Int)
    case fetchImage(imjangId: Int)
    case addImage
    case deleteImage
    case uploadRecordFile
    case fetchRecordFiles(imjangId: Int)
    case deleteRecordFile(recordId: Int)
    case editRecordName(recordId: Int, recordName: String)
    case editRecordContent(recordId: Int, content: String)
    
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
            
        case .showChecklist(let imjangId):
            return URL(string: baseURL + "checklist/\(imjangId)")!
        case .saveChecklist(let imjangId):
            return URL(string: baseURL + "checklist/\(imjangId)")!
        case .modifyChecklist(let imjangId):
            return URL(string: baseURL + "checklist/\(imjangId)")!
            
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
         
        case .fetchImage(imjangId: let imjangId):
            return URL(string: baseURL + "limjang/image/\(imjangId)")!
        case .addImage:
            return URL(string: baseURL + "limjang/image")!
        case .deleteImage:
            return URL(string: baseURL + "limjang/image/delete")!
            
        case .uploadRecordFile:
            return URL(string: baseURL + "record")!
        case .fetchRecordFiles(let imjangId):
            return URL(string: baseURL + "record/all/\(imjangId)")!
        case .deleteRecordFile(let recordId):
            return URL(string: baseURL + "record/\(recordId)")!
        case .editRecordName(let recordId, _):
            return URL(string: baseURL + "record/title/\(recordId)")!
        case .editRecordContent(let recordId, _):
            return URL(string: baseURL + "record/content/\(recordId)")!
        }
    }
    
    var header: HTTPHeaders {
        switch self {
        case .addImage, .uploadRecordFile:
            return [
                "Content-Type": "multipart/form-data",
                "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
            ]
        default:
            return ["Content-Type": "application/json",
                    "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .saveChecklist, .scrap, .createImjang, .regenerateToken, .logout, .deleteImjangs, .memo, .addImage, .deleteImage, .uploadRecordFile:
            return .post
        case .showChecklist, .totalImjang, .searchImjang, .mainImjang, .detailImjang, .kakaoLogin, .kakaoLoginCallback, .profile, .fetchRecordingRoom, .fetchImage, .fetchRecordFiles:
            return .get
        case .nickname, .modifyImjang, .modifyChecklist, .editRecordName, .editRecordContent:
            return .patch
        case .deleteRecordFile:
            return .delete
        }
    }
    
    var parameter: [String: Any] {
        switch self {
        case .totalImjang(let sort):
            return ["sort":sort]
        case .detailImjang(let imjangId):
            return  ["limjangIdList": imjangId]
        case .editRecordName(_, let recordName):
            return ["recordName": recordName]
        case .editRecordContent(_, let content):
            return ["recordScript": content]
        default:
            return [:]
        }
    }
}
