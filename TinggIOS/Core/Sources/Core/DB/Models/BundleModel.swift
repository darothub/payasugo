//
//  BundleModel.swift
//  
//
//  Created by Abdulrasaq on 15/06/2023.
//

import Foundation
public struct BundleModel {
    public var selectedBundle: String
    public var selectedAccount: String
    public var selectedDataPlan: String
    public var mobileNumber: String
    public var service: MerchantService
    public init(selectedBundle: String = "", selectedAccount: String = "", selectedDataPlan: String = "", mobileNumber: String = "", service: MerchantService = MerchantService()) {
        self.selectedBundle = selectedBundle
        self.selectedAccount = selectedAccount
        self.selectedDataPlan = selectedDataPlan
        self.mobileNumber = mobileNumber
        self.service = service
    }
    
}
