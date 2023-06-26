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
    private var dbObserver: Observer<CountriesInfo>
    /// ``CountryRepositoryImpl`` initialiser
    /// - Parameters:
    ///   - baseRequest: ``BaseRequest``
    ///   - dbObserver: ``Observer``
    public init(baseRequest: BaseRequest, dbObserver: Observer<CountriesInfo>) {
        self.baseRequest = baseRequest
        self.dbObserver =  dbObserver
    }
    private func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        baseRequest.makeRequest(urlPath: "countriesNew.php/", tinggRequest: .Builder().build()) {(result: Result<CountryDTO, ApiError>) in
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
    public func getCountries() async throws -> DTOandObjectWrapper<CountriesInfoDTO, CountriesInfo> {
        let dbCountries = await dbObserver.getEntities()
        if dbCountries.isEmpty {
            let remoteData = try await getRemoteCountries().data
            await dbObserver.saveEntities(objs: remoteData.map {$0.convertToCountriesInfo()})
            return DTOandObjectWrapper(dtos: remoteData, objs: remoteData.map {$0.convertToCountriesInfo()})
        }
        return DTOandObjectWrapper(dtos: [], objs: dbCountries)
    }
    
    public func getCountryByDialCode(dialCode: String) -> CountriesInfoDTO? {
        let dbCountries =  dbObserver.getEntities()
        let country = dbCountries.first { country in
            country.countryDialCode == dialCode
        }
        return country?.convertToDTO()
    }
    
}
