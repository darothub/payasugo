//
//  CategoryDTO.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
// MARK: - CategoryDTO
public struct CategoryDTO: Codable {
    public var categoryID, categoryName: String
    public var categoryLogo: String
    public var activeStatus, categoryOrderID: StringOrIntEnum
    public var showInHomepage: Int? = 0
    public init(categoryID: String = "", categoryName: String = "", categoryLogo: String = "", activeStatus: StringOrIntEnum = .integer(0), categoryOrderID: StringOrIntEnum = .string("0"), showInHomepage: Int? = 0) {
        self.categoryID = categoryID
        self.categoryName = categoryName
        self.categoryLogo = categoryLogo
        self.activeStatus = activeStatus
        self.categoryOrderID = categoryOrderID
        self.showInHomepage = showInHomepage
    }

    enum CodingKeys: String, CodingKey {
        case categoryID = "CATEGORY_ID"
        case categoryName = "CATEGORY_NAME"
        case categoryLogo = "CATEGORY_LOGO"
        case activeStatus = "ACTIVE_STATUS"
        case categoryOrderID = "CATEGORY_ORDER_ID"
        case showInHomepage = "SHOW_IN_HOMEPAGE"
    }
    
    public var toEntity: CategoryEntity {
        let entity = CategoryEntity()
        entity.categoryID = self.categoryID
        entity.categoryName = self.categoryName
        entity.showInHomepage = self.showInHomepage!
        entity.categoryLogo = self.categoryLogo
        entity.activeStatus = self.activeStatus.toString
        entity.categoryOrderID = self.categoryOrderID.toString
        return entity
    }
    public var isActive: Bool {
        let result = activeStatus.toString == "0" ? false : true
        return result
    }
}
