//
//  UserDefaultManager.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//
import Foundation

class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() { }
    
    enum UDKey: String, CaseIterable {
        case searchKeywords
        case accessToken
        case refreshToken
        case nickname
        case userStatus
        case email
    }
    
    let ud = UserDefaults.standard
    
    var searchKeywords: [String] {
        get { ud.array(forKey: UDKey.searchKeywords.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.searchKeywords.rawValue) }
    }
    
    var accessToken: String {
        get { ud.string(forKey: UDKey.accessToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.accessToken.rawValue) }
    }
    
    var refreshToken: String {
        get { ud.string(forKey: UDKey.refreshToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.refreshToken.rawValue) }
    }
    
    var nickname: String {
        get { ud.string(forKey: UDKey.nickname.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.nickname.rawValue) }
    }
    
    var userStatus: Bool {
        get { ud.bool(forKey: UDKey.userStatus.rawValue) }
        set { ud.set(newValue, forKey: UDKey.userStatus.rawValue) }
    }
    
    var email: String {
        get { ud.string(forKey: UDKey.email.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.email.rawValue) }
    }
}


