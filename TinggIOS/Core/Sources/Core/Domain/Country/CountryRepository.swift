//
//  File.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//

import Foundation
public class CountryRepository {
    var apiService: TinggApiServices
    var realmManager: RealmManager
    public init(apiService: TinggApiServices, realmManager: RealmManager) {
        self.apiService = apiService
        self.realmManager = realmManager
    }

    func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        apiService.getCountries()
            .responseDecodable(of: CountryDTO.self) {response in
                switch response.result {
                case .failure:
                    onCompletion(.failure(.networkError))
                case .success(let countries):
                    onCompletion(.success(countries))
                }
            }
    }
    func getRemoteCountries() async throws -> CountryDTO {
        return try await withCheckedThrowingContinuation { continuation in
            getCountries { result in
                continuation.resume(with: result)
            }
        }
    }
}
