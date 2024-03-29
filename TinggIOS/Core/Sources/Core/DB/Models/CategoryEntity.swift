//
//  CategoryEntity.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - Category
public class CategoryEntity: Object, DBObject, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var categoryID: String = ""
    @Persisted public var categoryName: String = ""
    @Persisted public var categoryLogo: String = ""
    @Persisted public var activeStatus: String = "0"
    @Persisted public var categoryOrderID: String = "-1"
    @Persisted public var quickAction: String? = ""
    @Persisted public var showInHomepage: Int
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
    public var toDTO: CategoryDTO {
        var dto = CategoryDTO()
        dto.categoryID = self.categoryID
        dto.categoryName = self.categoryName
        dto.showInHomepage = self.showInHomepage
        dto.categoryLogo = self.categoryLogo
        dto.activeStatus = .string(self.activeStatus)
        dto.categoryOrderID = .string(self.categoryOrderID)
        dto.showInHomepage = self.showInHomepage
        return dto
    }
    public var isActive: Bool {
        let result = activeStatus == "0" ? false : true
        return result
    }
}
