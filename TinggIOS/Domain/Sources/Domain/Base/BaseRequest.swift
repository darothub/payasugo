//
//  File.swift
//  
//
//  Created by Abdulrasaq on 19/07/2022.
//

import Core
import Foundation
public class BaseRequest: ObservableObject {
    let countryApiServices: TinggApiServices
    public init(countryServices: TinggApiServices) {
        self.countryApiServices = countryServices
    }
    public func makeRequest<T: BaseDTOprotocol>(tinggRequest: TinggRequest,
                        onCompletion: @escaping(Result<T, ApiError>) -> Void) {
        countryApiServices.request(tinggRequest: tinggRequest)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: T.self, emptyResponseCodes: [200, 204, 205]) { response in
                switch response.result {
                case .failure :
                    print("response \(response)")
                    onCompletion(.failure(.networkError))
                case .success(let baseResponse):
                    onCompletion(.success(baseResponse))
                }
            }
    }
}
