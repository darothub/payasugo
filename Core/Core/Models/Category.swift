//
//  Category.swift
//  Core
//
//  Created by Abdulrasaq on 01/06/2022.
//

import Foundation
public class Category : Identifiable, Codable {
    public let id: String = ""
    public let name: String? = nil
    public let logo: String? = nil
    public let activeStatus: String? = nil
    public let orderId: String? = nil
    public let quickAction: String? = nil
    public let showInHomepage: String? = nil
    enum CodingKeys: String, CodingKey {
        case id = "CATEGORY_ID"
        case name = "CATEGORY_NAME"
        case logo = "CATEGORY_LOGO"
        case activeStatus = "ACTIVE_STATUS"
        case orderId = "CATEGORY_ORDER_ID"
        case quickAction = "CATEGORY_IS_QUICK_ACTION"
        case showInHomepage = "SHOW_IN_HOMEPAGE"
    }
}
