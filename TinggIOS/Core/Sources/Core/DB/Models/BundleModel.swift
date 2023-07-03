//
//  BundleModel.swift
//  
//
//  Created by Abdulrasaq on 15/06/2023.
//

import Foundation
public struct BundleModel {
    public var selectedBundleName: String
    public var selectedAccount: String
    public var selectedDataPlanName: String
    public var mobileNumber: String
    public var service: MerchantService
    public var selectedBundleObject: BundleObject = .init()
    public init(selectedBundle: String = "", selectedAccount: String = "", selectedDataPlan: String = "", mobileNumber: String = "", service: MerchantService = MerchantService()) {
        self.selectedBundleName = selectedBundle
        self.selectedAccount = selectedAccount
        self.selectedDataPlanName = selectedDataPlan
        self.mobileNumber = mobileNumber
        self.service = service
    }
    
}
