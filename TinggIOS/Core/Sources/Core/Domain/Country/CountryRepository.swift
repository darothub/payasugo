//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public protocol CountryRepository {
    func getCountries() async throws -> [Country]
}