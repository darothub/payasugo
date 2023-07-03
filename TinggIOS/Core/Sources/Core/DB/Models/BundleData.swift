//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/11/2022.
//
import RealmSwift
import Foundation
// MARK: - BundleDatum
public class BundleData: Object, ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var bundleCategoryID: Int
    @Persisted public var categoryName: String
    @Persisted public var position: Int
    @Persisted public var serviceID: Int
    @Persisted public var bundles = RealmSwift.List<BundleObject>()

    enum CodingKeys: String, CodingKey {
        case bundleCategoryID = "BUNDLE_CATEGORY_ID"
        case categoryName = "CATEGORY_NAME"
        case position = "POSITION"
        case serviceID = "SERVICE_ID"
        case bundles = "BUNDLES"
    }
}

// MARK: - Bundle
public class BundleObject: Object, ObjectKeyIdentifiable, Codable {
    @Persisted public var bundleID: Int
    @Persisted public var bundleName: String
    @Persisted public var position: Int
    @Persisted public var cost: Int
    @Persisted public var bundleCode: String?

    enum CodingKeys: String, CodingKey {
        case bundleID = "BUNDLE_ID"
        case bundleName = "BUNDLE_NAME"
        case position = "POSITION"
        case cost = "COST"
        case bundleCode = "BUNDLE_CODE"
    }
}
