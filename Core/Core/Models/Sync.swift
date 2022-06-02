//
//  Sync.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation
// MARK: - Sync
public class Sync:Identifiable, Codable {
    public let id: Int
    public let hubPrimaryKey, tablePrimaryKey, tableName, tableAction: String?
    public let syncStatus, checkSum, lastSyncAttempt: String?

    enum CodingKeys: String, CodingKey {
        case id, hubPrimaryKey, tablePrimaryKey, tableName, tableAction, syncStatus, checkSum, lastSyncAttempt
    }

    init(id: Int, hubPrimaryKey: String?, tablePrimaryKey: String?, tableName: String?, tableAction: String?, syncStatus: String?, checkSum: String?, lastSyncAttempt: String?) {
        self.id = 0
        self.hubPrimaryKey = hubPrimaryKey
        self.tablePrimaryKey = tablePrimaryKey
        self.tableName = tableName
        self.tableAction = tableAction
        self.syncStatus = syncStatus
        self.checkSum = checkSum
        self.lastSyncAttempt = lastSyncAttempt
    }
}

