//
//  Highlight.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation
import RealmSwift

// MARK: - Highlight
public class Highlight: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var activeStatus:String?
    @Persisted public var title:String?
    @Persisted public var actionName:String?
    @Persisted public var highlightDESCRIPTION: String?
    @Persisted public var hasDeepLink:String?
    @Persisted public var categoryID:String?
    @Persisted public var serviceID:String?
    @Persisted public var imageURL: String?
    @Persisted public var deepLink:String?
    @Persisted public var dynamicLink:String?
    @Persisted public var amount:String?
    @Persisted public var priority: String?

    enum CodingKeys: String, CodingKey {
        case id
        case activeStatus = "ACTIVE_STATUS"
        case title = "TITLE"
        case actionName = "ACTION_NAME"
        case highlightDESCRIPTION = "DESCRIPTION"
        case hasDeepLink = "HAS_DEEP_LINK"
        case categoryID = "CATEGORY_ID"
        case serviceID = "SERVICE_ID"
        case imageURL = "IMAGE_URL"
        case deepLink = "DEEP_LINK"
        case dynamicLink = "DYNAMIC_LINK"
        case amount = "AMOUNT"
        case priority = "PRIORITY"
    }

    init(activeStatus: String?, title: String?, actionName: String?, highlightDESCRIPTION: String?, hasDeepLink: String?, categoryID: String?, serviceID: String?, imageURL: String?, deepLink: String?, dynamicLink: String?, amount: String?, priority: String?) {
        self.activeStatus = activeStatus
        self.title = title
        self.actionName = actionName
        self.highlightDESCRIPTION = highlightDESCRIPTION
        self.hasDeepLink = hasDeepLink
        self.categoryID = categoryID
        self.serviceID = serviceID
        self.imageURL = imageURL
        self.deepLink = deepLink
        self.dynamicLink = dynamicLink
        self.amount = amount
        self.priority = priority
    }
}
