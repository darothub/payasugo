//
//  File.swift
//  
//
//  Created by Abdulrasaq on 19/07/2022.
//

import Foundation
public class BaseRequest: ObservableObject {
    let apiServices: TinggApiServices
    public init(apiServices: TinggApiServices) {
        self.apiServices = apiServices
    }
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        apiServices.request(tinggRequest: tinggRequest)
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
