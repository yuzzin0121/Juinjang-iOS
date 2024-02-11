//
//  JuinjangAPIManager.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
}

final class JuinjangAPIManager {
    static let shared = JuinjangAPIManager()
    private init() { }
    
    func fetchData<T: Decodable>(type: T.Type, api: JuinjangAPI, completionHandler: @escaping (T?, NetworkError?) -> Void) {
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString),
                   headers: api.header)
       .responseDecodable(of: type) { response in
           switch response.result {
           case .success(let success):
               completionHandler(success, nil)
           case .failure(let failure):
               print(failure)
               completionHandler(nil, .failedRequest)
               fatalError("네트워킹 오류")
           }
       }
    }
}
