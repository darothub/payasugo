//
//  MerchantService.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation
public class MerchantService: Codable {
    public let hubServiceID: String
    public let isDislayableOnLifestream, isRefresh, isCyclicService: Bool
    public let isManualBill: String
    public let selected: Bool
    public let genericForm, dynamicFormType, kplcPrepaidID, secretGardenID: String
    public let britamContributionID, mulaChamaID, pdslPrepaidID, favouriteDisplayModeShowAll: String
    public let favouriteDisplayModeShowPerOption: String

    enum CodingKeys: String, CodingKey {
        case hubServiceID = "HUB_SERVICE_ID"
        case isDislayableOnLifestream = "IS_DISLAYABLE_ON_LIFESTREAM"
        case isRefresh = "IS_REFRESH"
        case isCyclicService = "IS_CYCLIC_SERVICE"
        case isManualBill, selected
        case genericForm = "GENERIC_FORM"
        case dynamicFormType = "DYNAMIC_FORM_TYPE"
        case kplcPrepaidID = "KPLC_PREPAID_ID"
        case secretGardenID = "SECRET_GARDEN_ID"
        case britamContributionID = "BRITAM_CONTRIBUTION_ID"
        case mulaChamaID = "MULA_CHAMA_ID"
        case pdslPrepaidID = "PDSL_PREPAID_ID"
        case favouriteDisplayModeShowAll = "FAVOURITE_DISPLAY_MODE_SHOW_ALL"
        case favouriteDisplayModeShowPerOption = "FAVOURITE_DISPLAY_MODE_SHOW_PER_OPTION"
    }
}

