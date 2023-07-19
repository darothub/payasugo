//
//  File.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//

import Foundation
import RealmSwift

public class CountryRepositoryImpl: CountryRepository {

    private var baseRequest: TinggApiServices
    private var dbObserver: Observer<CountryInfo>
    /// ``CountryRepositoryImpl`` initialiser
    /// - Parameters:
    ///   - baseRequest: ``TinggApiServices``
    ///   - dbObserver: ``Observer``
    public init(baseRequest: TinggApiServices, dbObserver: Observer<CountryInfo>) {
        self.baseRequest = baseRequest
        self.dbObserver =  dbObserver
    }
    private func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        baseRequest.makeRequest(urlPath: "countriesNew.php/", tinggRequest: .Builder().build()) { (result: Result<CountryDTO, ApiError>) in
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
    /// A method to get countries from local and remote repositories
    /// - Returns: a list of ``Country``
    @MainActor
    public func getCountries() async throws -> [CountriesInfoDTO] {
        let dbCountries = dbObserver.getEntities()
        if dbCountries.isEmpty {
            let remoteData = try await getRemoteCountries().data
            let countries: [CountryInfo] = remoteData.map {
                $0.convertToCountriesInfo()
            }
            dbObserver.saveEntities(objs: countries)
            return remoteData
        }
        let countries: [CountriesInfoDTO] = dbCountries.map {
            $0.convertToDTO()
        }
        return countries
    }
    
    public func getCountryByDialCode(dialCode: String) -> CountriesInfoDTO? {
        let dbCountries =  dbObserver.getEntities()
        let country = dbCountries.first { country in
            country.countryDialCode == dialCode
        }
        return country?.convertToDTO()
    }
    
}
