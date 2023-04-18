//
//  FormParameter.swift
//  
//
//  Created by Abdulrasaq on 13/03/2023.
//

import Foundation
// MARK: - FormParameter
public struct FormParameter: Codable {
    public let itemName, displayName, itemType, isReferenceField: String?
    public let keyValueData, name: String?
    public let items: [Item]?

    enum CodingKeys: String, CodingKey {
        case itemName = "ITEM_NAME"
        case displayName = "DISPLAY_NAME"
        case itemType = "ITEM_TYPE"
        case isReferenceField = "IS_REFERENCE_FIELD"
        case keyValueData = "KEY_VALUE_DATA"
        case name = "NAME"
        case items = "ITEMS"
    }
   public var toEntity: FormParameterEntity {
        var entity = FormParameterEntity()
        entity.name = self.name
        entity.itemName = self.itemName
        entity.displayName = self.displayName
        entity.isReferenceField = self.isReferenceField
       let itemEntity = self.items?.map({ item in
           item.toEntity
       }) ?? []
       entity.items.append(objectsIn: itemEntity)
       return entity
    }
}

// MARK: - Item
public struct Item: Codable {
    public let itemID: Int
    public let name: String
    public let amount: Int

    enum CodingKeys: String, CodingKey {
        case itemID = "ITEM_ID"
        case name = "NAME"
        case amount = "AMOUNT"
    }
    public var toEntity: ItemEntity {
        var entity = ItemEntity()
        entity.name = self.name
        entity.amount = self.amount
        entity.itemID = self.itemID
        return entity
    }
}
