//
//  UserDefaultManager.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//
import Foundation
import UIKit

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
        case profileImage
        case isKakaoLogin
        case identityToken
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
    
    var profileImage: UIImage? {
        get {
            if let imageData = ud.data(forKey: UDKey.profileImage.rawValue) {
                return UIImage(data: imageData)
            }
            return nil
        }
        set {
            if let image = newValue, let imageData = image.pngData() {
                ud.set(imageData, forKey: UDKey.profileImage.rawValue)
            } else {
                ud.removeObject(forKey: UDKey.profileImage.rawValue)
            }
        }
    }
    
    var isKakaoLogin: Bool {
        get { ud.bool(forKey: UDKey.isKakaoLogin.rawValue) }
        set { ud.set(newValue, forKey: UDKey.isKakaoLogin.rawValue) }
    }
    
    var identityToken: String {
        get { ud.string(forKey: UDKey.identityToken.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.identityToken.rawValue) }
    }
}


