//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//

import Foundation
public protocol MerchantServiceRepository {
    func getServices() -> [MerchantService]
}
