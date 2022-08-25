//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//
import Foundation

public class GetCountriesUsecaseImpl: GetCountriesUsecase {
    public let countryRepository: CountryRepository
    public init (countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
    }
    public func callAsFunction() async throws -> [String : String]{
        return try await countryRepository.getCountriesAndDialCode()
    }
    public func callAsFunction(dialCode: String) -> Country? {
        return countryRepository.getCountryByDialCode(dialCode: dialCode)
    }
}

public protocol GetCountriesUsecase {
    func callAsFunction() async throws -> [String : String]
    func callAsFunction(dialCode: String) -> Country?
}
