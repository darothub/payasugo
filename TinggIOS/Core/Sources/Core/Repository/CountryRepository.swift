//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public protocol CountryRepository {
    func getCountriesAndDialCode() async throws -> [String: String]
    func getCountryByDialCode(dialCode: String) -> Country?
}
