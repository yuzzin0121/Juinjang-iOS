//
//  JuinjangAPIManager.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
import Alamofire
import UIKit

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
        
        print("\(api.header)")
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameter,
                   encoding: api.encoding,
                   headers: api.header)
       .responseDecodable(of: type) { response in
           switch response.result {
           case .success(let success):
               completionHandler(success, nil)
           case .failure(let failure):
               print(failure)
               completionHandler(nil, .failedRequest)
//               fatalError("네트워킹 오류")
           }
       }
    }
    
    func deleteImjang<T: Decodable>(type: T.Type, api: JuinjangAPI, ids: [Int], completionHandler: @escaping (T?, NetworkError?) -> Void) {
        
        let parameter: [String: Any] = [
            "limjangIdList": ids
        ]
        
        print("\(api.header)")
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: parameter,
                   encoding: api.encoding,
                   headers: api.header)
       .responseDecodable(of: type) { response in
           switch response.result {
           case .success(let success):
               completionHandler(success, nil)
           case .failure(let failure):
               print(failure)
               completionHandler(nil, .failedRequest)
//               fatalError("네트워킹 오류")
           }
       }
    }
    
    
    func uploadImages(images: [UIImage], api: JuinjangAPI, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            for (index, image) in images.enumerated() {
                guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
                // "imgUrl" 키에 대한 배열 형식으로 이미지 데이터를 전송
                multipartFormData.append(imageData, withName: "imgUrl", fileName: "image\(index).jpg", mimeType: "image/jpeg")
            }
        }, to: api.endpoint, method: .post, headers: headers)
        .validate()
        .response { response in
            switch response.result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
