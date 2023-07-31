//
//  CustomRequestInterceptor.swift
//
//
//  Created by Abdulrasaq on 28/07/2023.
//
import Alamofire
import Foundation

class CustomRequestInterceptor: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        // Modify the URLRequest, for example, by adding custom headers
        var modifiedRequest = urlRequest
        let token = AppStorageManager.getToken()
        let ecnryptionVersion = "1"
        modifiedRequest.addValue(token, forHTTPHeaderField: "Authorization")
        modifiedRequest.addValue(ecnryptionVersion, forHTTPHeaderField:  "X-Encryption-Version")
        completion(.success(modifiedRequest))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // You can implement retry logic here if necessary
        completion(.doNotRetry)
    }
}
