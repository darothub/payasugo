//
//  BundleDatum.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - BundleDatum
public struct BundleDatum: Codable {
    let bundleCategoryID: Int
    let categoryName: String
    let position, serviceID: Int
    let bundles: [Bundle]

    enum CodingKeys: String, CodingKey {
        case bundleCategoryID = "BUNDLE_CATEGORY_ID"
        case categoryName = "CATEGORY_NAME"
        case position = "POSITION"
        case serviceID = "SERVICE_ID"
        case bundles = "BUNDLES"
    }
    public var toEntity: BundleData {
        let entity = BundleData()
        entity.bundleCategoryID = self.bundleCategoryID
        entity.categoryName = self.categoryName
        entity.position = self.position
        entity.serviceID = self.serviceID
        entity.bundles.append(objectsIn: bundles.map {$0.toEntity})
        return entity
    }
}

// MARK: - Bundle
public struct Bundle: Codable {
    let bundleID: Int
    let bundleName: String
    let position: Int
    let cost: DynamicType
    let bundleCode: String?

    enum CodingKeys: String, CodingKey {
        case bundleID = "BUNDLE_ID"
        case bundleName = "BUNDLE_NAME"
        case position = "POSITION"
        case cost = "COST"
        case bundleCode = "BUNDLE_CODE"
    }
    public var toEntity: BundleObject {
        let entity = BundleObject()
        entity.bundleID = self.bundleID
        entity.bundleName = self.bundleName
        entity.position = self.position
        entity.cost = self.cost.toInt
        entity.bundleCode = self.bundleCode
        return entity
    }
}
