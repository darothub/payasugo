//
//  File.swift
//  
//
//  Created by Abdulrasaq on 08/07/2022.
//
import ApiModule
import Core
import Foundation
public class ConfirmActivationCode: ObservableObject {
    let countryApiServices: CountryApiServices
    public init() {
        self.countryApiServices = CountryRepository()
    }
    public func confirmCode(activationCodeRequest: TinggRequest, onCompletion: @escaping(Result<BaseDTO, ApiError>) -> Void) {
        countryApiServices.getActivationCode(activationCodeRequest: activationCodeRequest)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: BaseDTO.self, emptyResponseCodes: [200, 204, 205]) { response in
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
