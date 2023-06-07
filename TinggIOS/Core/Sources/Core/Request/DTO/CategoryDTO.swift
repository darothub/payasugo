//
//  CategoryDTO.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
// MARK: - CategoryDTO
public struct CategoryDTO: Codable {
    public let categoryID, categoryName: String
    public let categoryLogo: String
    public let activeStatus, categoryOrderID: StringOrIntEnum
    public let showInHomepage: Int = 0

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
        entity.showInHomepage = self.showInHomepage
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
