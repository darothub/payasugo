//
//  GetCountriesAndDialCodeUseCase.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//

import Core
import Foundation

public class GetCountriesAndDialCodeUseCase {
    public let countryRepository: CountryRepository
    /// ``GetCountriesAndDialCodeUseCase`` initialiser
    /// - Parameter countryRepository: ``CountryRepositoryImpl``
    public init (countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
    }
    /// A call as function to get country dialcode and country code
    /// - Returns: return as dictionary of  ``Country/countryCode`` and ``Country/countryDialCode``
    public func callAsFunction() async throws -> [String : String] {
        let latestCountries: [CountriesInfoDTO] = try await countryRepository.getCountries()
        var dict: [String : String] = .init()
        dict = Dictionary(uniqueKeysWithValues: latestCountries.map { ($0.countryCode!, $0.countryDialCode!) })
        return dict
    }
    /// A call as function to get country by dialcode
    /// - Parameter dialCode: ``Country/countryDialCode``
    /// - Returns: ``Country``
    public func callAsFunction(dialCode: String) -> CountriesInfoDTO? {
        return countryRepository.getCountryByDialCode(dialCode: dialCode)
    }
}

