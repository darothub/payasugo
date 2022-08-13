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
    public var apiService: TinggApiServices
    public var realmManager: RealmManager
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


public protocol CountryRepository {
    func getCountries() async throws -> [Country]
}
