//
//  Category.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - Category
public class Category: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted public var categoryID: String? = ""
    @Persisted public var categoryName: String? = ""
    @Persisted public var categoryLogo: String? = ""
    @Persisted public var activeStatus: String? = ""
    @Persisted public var categoryOrderID: String? = ""
    @Persisted public var quickAction: String? = ""
    @Persisted public var showInHomepage: String? = ""
    @Persisted public var parkingID: String? = ""
    @Persisted public var payTvID: String? = ""
    @Persisted public var powerID: String? = ""
    @Persisted public var internetID: String? = ""
    @Persisted public var waterID: String? = ""
    @Persisted public var airtimeID: String? = ""
    @Persisted public var gasID: String? = ""
    @Persisted public var otherID: String? = ""
    @Persisted public var investID: String? = ""

    enum CodingKeys: String, CodingKey {
        case categoryID = "CATEGORY_ID"
        case categoryName = "CATEGORY_NAME"
        case categoryLogo = "CATEGORY_LOGO"
        case activeStatus = "ACTIVE_STATUS"
        case categoryOrderID = "CATEGORY_ORDER_ID"
        case quickAction
        case showInHomepage = "SHOW_IN_HOMEPAGE"
        case parkingID = "PARKING_ID"
        case payTvID = "PAY_TV_ID"
        case powerID = "POWER_ID"
        case internetID = "INTERNET_ID"
        case waterID = "WATER_ID"
        case airtimeID = "AIRTIME_ID"
        case gasID = "GAS_ID"
        case otherID = "OTHER_ID"
        case investID = "INVEST_ID"
    }
//    init(
//        categoryID: String?, categoryName: String?, categoryLogo: String?,
//        activeStatus: String?, categoryOrderID: String?, quickAction: String?,
//        showInHomepage: String?, parkingID: String?, payTvID: String?,
//        powerID: String?, internetID: String?, waterID: String?,
//        airtimeID: String?, gasID: String?, otherID: String?,
//        investID: String?
//    ) {
//        self.categoryID = categoryID
//        self.categoryName = categoryName
//        self.categoryLogo = categoryLogo
//        self.activeStatus = activeStatus
//        self.categoryOrderID = categoryOrderID
//        self.quickAction = quickAction
//        self.showInHomepage = showInHomepage
//        self.parkingID = parkingID
//        self.payTvID = payTvID
//        self.powerID = powerID
//        self.internetID = internetID
//        self.waterID = waterID
//        self.airtimeID = airtimeID
//        self.gasID = gasID
//        self.otherID = otherID
//        self.investID = investID
//    }
}
