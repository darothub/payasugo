//
//  Highlight.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation

// MARK: - Highlight
public class Highlight: Codable {
    public let id: Int
    public let activeStatus, title, actionName, highlightDESCRIPTION: String?
    public let hasDeepLink, categoryID, serviceID, imageURL: String?
    public let deepLink, dynamicLink, amount, priority: String?

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

    init(id: Int, activeStatus: String?, title: String?, actionName: String?, highlightDESCRIPTION: String?, hasDeepLink: String?, categoryID: String?, serviceID: String?, imageURL: String?, deepLink: String?, dynamicLink: String?, amount: String?, priority: String?) {
        self.id = 0
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
