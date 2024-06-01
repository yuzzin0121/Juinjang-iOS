//
//  JuinjangAPIManager.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation
import Alamofire
import UIKit

enum NetworkError: Error, LocalizedError {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    
    var errorDescription: String? {
        switch self {
        case .failedRequest:
            return "요청에 실패하였습니다. 다시 시도해주세요"
        case .noData:
            return "응답 데이터가 없습니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .invalidData:
            return "유효하지 않은 데이터입니다."
        }
    }
}

final class JuinjangAPIManager {
    static let shared = JuinjangAPIManager()
    private init() { }
    
    func fetchData<T: Decodable>(type: T.Type, api: JuinjangAPI, completionHandler: @escaping (T?, NetworkError?) -> Void) {
        
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: api.parameter,
                   headers: api.header,
                   interceptor: AuthInterceptor())
        .responseDecodable(of: type) { response in
            print("StatusCode: \(response.response?.statusCode)", UserDefaultManager.shared.accessToken)
            switch response.result {
            case .success(let success):
                completionHandler(success, nil)
            case .failure(let failure):
                print(failure)
                completionHandler(nil, .failedRequest)            }
        }
    }
    
    func postData<T: Decodable>(type: T.Type, api: JuinjangAPI, parameter: [String:Any], completionHandler: @escaping (T?, NetworkError?) -> Void) {
        
        AF.request(api.endpoint,
                   method: api.method,
                   parameters: parameter,
                   encoding: JSONEncoding.default,
                   headers: api.header,
                   interceptor: AuthInterceptor())
        .responseDecodable(of: type) { response in
            print("StatusCode: \(response.response?.statusCode)")
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
    
    func uploadImages(imjangId: Int, images: [UIImage], api: JuinjangAPI, completion: @escaping (Result<Void, Error>) -> Void) {
        
        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append("\(imjangId)".data(using: .utf8)!, withName: "limjangId")
            for (index, image) in images.enumerated() {
                guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
                // "imgUrl" 키에 대한 배열 형식으로 이미지 데이터를 전송
                multipartFormData.append(imageData, withName: "images", fileName: "image\(index).jpeg", mimeType: "image/jpeg")
            }
        }, to: api.endpoint, method: api.method, headers: api.header, interceptor: AuthInterceptor())
        .validate()
        .response { response in
            print("StatusCode: \(response.response?.statusCode)")
            switch response.result {
            case .success:
                print(response)
                completion(.success(()))
            case .failure(let error):
                print(error)
                completion(.failure(error))
            }
        }
    }
    
    func uploadRecordFile(api: JuinjangAPI, fileURL: URL, dto: RecordRequestDTO, completionHandler: @escaping (Result<RecordResponse, NetworkError>) -> Void) {
        
        AF.upload(multipartFormData: { [weak self] multipartFormData in
            guard let self else { return }
            multipartFormData.append(fileURL, withName: "file", fileName: "record_1.m4a", mimeType: "audio/mp4")
            
            if let jsonData = encodeToJSONData(dto) {
                print(dto)
                multipartFormData.append(jsonData, withName: "recordRequestDTO", mimeType: "application/json")
            }
        }, to: api.endpoint, method: api.method, headers: api.header, interceptor: AuthInterceptor()).responseDecodable(of: RecordResponseDTO.self, completionHandler: { response in
            print("StatusCode: \(response.response?.statusCode)")
            switch response.result {
            case .success(let responseData):
                guard let recordResponse = responseData.result else {
                    completionHandler(.failure(NetworkError.noData))
                    return
                }
                completionHandler(.success(recordResponse))
            case .failure(let error):
                print("Upload failed with error: \(error)")
                completionHandler(.failure(NetworkError.failedRequest))
            }
        })
    }
    
    func encodeToJSONData<T: Encodable>(_ value: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(value)
            return jsonData
        } catch {
            print("Encoding error: \(error)")
            return nil
        }
    }
    
    func refreshAccessToken(completionHandler: @escaping (Bool) -> Void) {
        let api = JuinjangAPI.regenerateToken
        AF.request(api.endpoint, method: api.method, headers: api.header)
            .responseDecodable(of: BaseResponse<RefreshDto>.self) { response in
                print(#function, "StatusCode: \(response.response?.statusCode)")
                switch response.result {
                case .success(let success):
                    guard let result = success.result else {
                        completionHandler(false)
                        return
                    }
                    UserDefaultManager.shared.accessToken = result.accessToken
                    UserDefaultManager.shared.refreshToken = result.refreshToken
                    completionHandler(true)
                case .failure(let failure):
                    completionHandler(false)
                }
            }
    }
}
