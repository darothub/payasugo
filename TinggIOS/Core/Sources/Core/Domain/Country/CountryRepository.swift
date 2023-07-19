//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public protocol CountryRepository {
    func getCountryByDialCode(dialCode: String) -> CountriesInfoDTO?
    func getCountries() async throws -> [CountriesInfoDTO]
}


