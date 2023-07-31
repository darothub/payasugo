//
//  BaseRequest.swift
//
//
//  Created by Abdulrasaq on 19/07/2022.
//

import Alamofire
import Foundation
/// Base request configuration for making Tingg API request
public class BaseRequest: TinggApiServices {
    public static let shared = BaseRequest()
    public var allowResponseDecryption: Bool
    public init(allowResponseDecryption: Bool = true) {
        self.allowResponseDecryption = allowResponseDecryption
    }

    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: RequestMap,
        onCompletion: @escaping (Result<T, ApiError>) -> Void
    ) {
        request(tinggRequest: tinggRequest)
            .validate(statusCode: 200 ..< 300)
            .execute { (result: Result<T, ApiError>) in
                onCompletion(result)
            }
    }

    public func makeRequest<T: BaseDTOprotocol>(
        urlPath: String,
        onCompletion: @escaping (Result<T, ApiError>) -> Void
    ) {
        request(urlPath: urlPath)
            .validate(statusCode: 200 ..< 400)
            .execute { (result: Result<T, ApiError>) in
                onCompletion(result)
            }
    }

    func result<T: BaseDTOprotocol>(urlPath: String, tinggRequest: RequestMap) async throws -> Result<T, ApiError> {
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(urlPath: urlPath, tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }

//    func result<T: BaseDTOprotocol>(tinggRequest: TinggRequest) async throws -> Result<T, ApiError> {
//        return try await withCheckedThrowingContinuation { continuation in
//            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
//                continuation.resume(returning: result)
//            }
//        }
//    }

    public func resultOfBasicAuthRequest<T: Decodable>(url: String, method: HTTPMethod, headers: HTTPHeaders?) async throws -> Result<T, ApiError> {
        return try await withCheckedThrowingContinuation { continuation in
            makeBasicAuthRequest(url: url, method: method, headers: headers, onCompletion: { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            })
        }
    }

    func result<T: Decodable>(url: String, method: HTTPMethod, parameters: [String: Any]) async throws -> Result<T, ApiError> {
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(url: url, method: method, parameters: parameters) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }

    public func result<T: Decodable>(_ parameters: [String: String]) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(parameters: parameters) { (result: Result<SecuredResponse, ApiError>) in
                switch result {
                case let .failure(error):
                    continuation.resume(throwing: error)
                case let .success(data):
                    if self.allowResponseDecryption {
                        guard let object: T? = data.decodeToFinal() else {
                            let object: BaseDTO? = data.decodeToFinal()
                            continuation.resume(throwing: ApiError.networkError(object!.statusMessage))
                            return
                        }
                        continuation.resume(returning: object!)
                    } else {
                        continuation.resume(returning: data as! T)
                    }
                }
            }
        }
    }

    func result<T: BaseDTOprotocol>(tinggRequest: RequestMap) async throws -> Result<T, ApiError> {
        return try await withCheckedThrowingContinuation { continuation in
            makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(returning: result)
            }
        }
    }
}

extension DataRequest {
    fileprivate func handleSuccess<T: BaseDTOprotocol>(_ decoder: JSONDecoder, _ data: String, _ onCompletion: @escaping (Result<T, ApiError>) -> Void) {
        do {
            // using JSONDecoder because of the anomalies from the backend
            let result = try decoder.decode(BaseDTO.self, from: data.data(using: .utf8)!)
            if result.statusCode >= 202 {
                print("Result202 above \(result)")
                onCompletion(.failure(.networkError(result.statusMessage)))
            } else {
                let result = try decoder.decode(T.self, from: data.data(using: .utf8)!)
                print("Result200 \(result)")
                onCompletion(.success(result))
            }
        } catch {
            let err = error as! DecodingError
            switch err {
            case let .dataCorrupted(context):
                print("Data corrupted: \(context)")
                onCompletion(.failure(.networkError("Data corrupted error")))
            case let .keyNotFound(key, context):
                print("Key not found: \(key), \(context)")
                onCompletion(.failure(.networkError("Key not found error")))
            case let .typeMismatch(type, context):
                print("Type mismatch: \(type), \(context)")
                onCompletion(.failure(.networkError("Type mismatch error")))
            case let .valueNotFound(type, context):
                print("Value not found: \(type), \(context)")
                onCompletion(.failure(.networkError("Value not found error")))
            @unknown default:
                print("Error200 \(error)")
                onCompletion(.failure(.networkError("error")))
            }
        }
    }

    func execute<T: BaseDTOprotocol>(onCompletion: @escaping (Result<T, ApiError>) -> Void) {
        responseString { response in
            let decoder = JSONDecoder()
            switch response.result {
            case let .success(data):
                if let httpResponse = response.response, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    self.handleSuccess(decoder, data, onCompletion)
                }
            case let .failure(error):
                print("FailureError \(error)")
                onCompletion(.failure(.networkError(error.localizedDescription)))
            }
        }
    }

    func execute<T: Decodable>(onCompletion: @escaping (Result<T, ApiError>) -> Void) {
        responseDecodable(of: T.self) { response in
            switch response.result {
            case let .success(data):
                print("Decodable \(data)")
                onCompletion(.success(data))
            case let .failure(error):
                print("DecodableError \(error)")
                onCompletion(.failure(.networkError(error.localizedDescription)))
            }
        }
    }

    fileprivate func handleSuccess<T: Decodable>(_ decoder: JSONDecoder, _ data: String, _ onCompletion: @escaping (Result<T, ApiError>) -> Void) {
        do {
            let result = try decoder.decode(T.self, from: data.data(using: .utf8)!)
            print("Result200 \(result)")
            onCompletion(.success(result))
        } catch {
            let err = error as! DecodingError
            switch err {
            case let .dataCorrupted(context):
                print("Data corrupted: \(context)")
                onCompletion(.failure(.networkError("Data corrupted error")))
            case let .keyNotFound(key, context):
                print("Key not found: \(key), \(context)")
                onCompletion(.failure(.networkError("Key not found error")))
            case let .typeMismatch(type, context):
                print("Type mismatch: \(type), \(context)")
                onCompletion(.failure(.networkError("Type mismatch error")))
            case let .valueNotFound(type, context):
                print("Value not found: \(type), \(context)")
                onCompletion(.failure(.networkError("Value not found error")))
            @unknown default:
                print("Error200 \(error)")
                onCompletion(.failure(.networkError("error")))
            }
        }
    }
}

extension Result<SecuredResponse, ApiError> {
    public var decrypt: String {
        switch self {
        case let .success(data):
            let response = data
            return response.json
        case let .failure(error):
            fatalError(error.localizedString)
        }
    }
}
