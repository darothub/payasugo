//
//  File.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//

import Foundation
import RealmSwift
public class CountryRepositoryImpl: CountryRepository {
    private var baseRequest: BaseRequest
    private var dbObserver: Observer<Country>
    public init(baseRequest: BaseRequest, dbObserver: Observer<Country>) {
        self.baseRequest = baseRequest
        self.dbObserver =  dbObserver
    }
    private func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        baseRequest.makeRequest(urlPath: "countries.php/") {(result: Result<CountryDTO, ApiError>) in
            switch result {
            case .failure(let error):
                onCompletion(.failure(.networkError(error.localizedDescription)))
            case .success(let countries):
                onCompletion(.success(countries))
            }
        }
    }
    private func getRemoteCountries() async throws -> CountryDTO {
        return try await withCheckedThrowingContinuation { continuation in
            getCountries { result in
                continuation.resume(with: result)
            }
        }
    }
    public func getCountries() async throws -> [Country] {
        if await dbObserver.getEntities().isEmpty {
            let remoteData = try await getRemoteCountries().data
            let localDb = try await Realm()
            localDb.writeAsync {
                localDb.add(remoteData, update: .modified)
            }
            return remoteData
        }
        return await dbObserver.getEntities()
    }
}
