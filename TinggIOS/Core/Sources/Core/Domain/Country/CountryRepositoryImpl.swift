//
//  File.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//

import Foundation
import RealmSwift
public class CountryRepositoryImpl: CountryRepository {
    @ObservedResults(Country.self) var countries
    public var baseRequest: BaseRequest
    public var realmManager: RealmManager
    public init(baseRequest: BaseRequest, realmManager: RealmManager) {
        self.baseRequest = baseRequest
        self.realmManager = realmManager
    }
    func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        baseRequest.makeRequest(urlPath: "countries.php/") {(result: Result<CountryDTO, ApiError>) in
            switch result {
            case .failure(let error):
                onCompletion(.failure(.networkError(error.localizedDescription)))
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
    public func getCountryByDialCode(dialCode: String) -> Country? {
        guard let country = realmManager.filterCountryByDialCode(dialCode: dialCode) else {
            return nil
        }
        return country
    }
    public func getCountriesAndDialCode() async throws -> [String: String] {
        let latestCountries = try await getCountries()
        let countryDictionary = latestCountries.reduce(into: [:]) { partialResult, country in
            partialResult[country.countryCode!] = country.countryDialCode
        }
        return countryDictionary
    }
    public func getCountries() async throws -> [Country] {
        let localDb = try await Realm()
        if countries.isEmpty {
            let remoteData = try await getRemoteCountries().data
            localDb.writeAsync {
                localDb.add(remoteData, update: .modified)
            }
            return remoteData
        }
        return countries.reversed()
    }
}
