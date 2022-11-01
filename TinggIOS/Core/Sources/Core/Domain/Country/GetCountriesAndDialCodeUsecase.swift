//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//
import Foundation
@MainActor
public class GetCountriesAndDialCodeUseCase {
    public let countryRepository: CountryRepository
    /// ``GetCountriesAndDialCodeUseCase`` initialiser
    /// - Parameter countryRepository: ``CountryRepositoryImpl``
    public init (countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
    }
    /// A call as function to get country dialcode and country code
    /// - Returns: return as dictionary of  ``Country/countryCode`` and ``Country/countryDialCode``
    public func callAsFunction() async throws -> [String : String]{
        let latestCountries = try await countryRepository.getCountries()
        let dict = Dictionary(uniqueKeysWithValues: latestCountries.map { ($0.countryCode!, $0.countryDialCode!) })

        return dict
    }
}
@MainActor
public class GetCountryByDialCodeUsecase {
    public let countryRepository: CountryRepository
    /// ``GetCountryByDialCodeUsecase``  initialiser
    /// - Parameter countryRepository: ``CountryRepositoryImpl``
    public init (countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
    }
    
    /// A call as function to get country by dialcode
    /// - Parameter dialCode: ``Country/countryDialCode``
    /// - Returns: ``Country``
    public func callAsFunction(dialCode: String) async throws -> Country? {
        let countries = try await countryRepository.getCountries()
        let country = countries.first { country in
            country.countryDialCode == dialCode
        }
        return country
    }
}

