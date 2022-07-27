//
//  Highlight.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift

// MARK: - Highlight
public class Highlight: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var activeStatus: Int
    @Persisted public var title: String
    @Persisted public var highlightDESCRIPTION: String?
    @Persisted public var hasDeepLink: Int
    @Persisted public var categoryID: Int
    @Persisted public var serviceID: Int
    @Persisted public var imageURL: String
    @Persisted public var deepLink: String
    @Persisted public var dynamicLink: String
    @Persisted public var amount: String
    @Persisted public var priority: Int
    @Persisted public var actionName: String

    enum CodingKeys: String, CodingKey {
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
}


