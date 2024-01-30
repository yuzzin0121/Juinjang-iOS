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
    }
    
    let ud = UserDefaults.standard
    
    var searchKeywords: [String] {
        get { ud.array(forKey: UDKey.searchKeywords.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.searchKeywords.rawValue) }
    }
}


