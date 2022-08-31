//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//
import Foundation

public class GetCountriesAndDialCodeUsecaseImpl: GetCountriesAndDialCodeUseCase {
    public let countryRepository: CountryRepository
    public init (countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
    }
    public func callAsFunction() async throws -> [String : String]{
        let latestCountries = try await countryRepository.getCountries()
        let countryDictionary = latestCountries.reduce(into: [:]) { partialResult, country in
            partialResult[country.countryCode!] = country.countryDialCode
        }
        return countryDictionary
    }
}

public class GetCountryByDialCodeUsecaseImpl: GetCountryByDialCodeUsecase {
    public let countryRepository: CountryRepository
    public init (countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
    }
    
    public func callAsFunction(dialCode: String) async throws -> Country? {
        let countries = try await countryRepository.getCountries()
        let country = countries.first { country in
            country.countryDialCode == dialCode
        }
        return country
    }
}

public protocol GetCountriesAndDialCodeUseCase {
    func callAsFunction() async throws -> [String : String]
}

public protocol GetCountryByDialCodeUsecase {
    func callAsFunction(dialCode: String) async throws -> Country?
}
