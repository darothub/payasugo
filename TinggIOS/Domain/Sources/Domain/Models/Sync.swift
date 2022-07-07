//
//  Sync.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift
// MARK: - Sync
public class Sync: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var id: ObjectId
    @Persisted public var hubPrimaryKey:String? = ""
    @Persisted public var tablePrimaryKey:String? = ""
    @Persisted public var tableName:String? = ""
    @Persisted public var tableAction: String? = ""
    @Persisted public var syncStatus:String? = ""
    @Persisted public var checkSum:String? = ""
    @Persisted public var lastSyncAttempt: String? = ""
    enum CodingKeys: String, CodingKey {
        case id, hubPrimaryKey, tablePrimaryKey, tableName, tableAction, syncStatus, checkSum, lastSyncAttempt
    }
//    init(
//        hubPrimaryKey: String?, tablePrimaryKey: String?, tableName: String?,
//        tableAction: String?, syncStatus: String?, checkSum: String?,
//        lastSyncAttempt: String?
//    ) {
//        self.hubPrimaryKey = hubPrimaryKey
//        self.tablePrimaryKey = tablePrimaryKey
//        self.tableName = tableName
//        self.tableAction = tableAction
//        self.syncStatus = syncStatus
//        self.checkSum = checkSum
//        self.lastSyncAttempt = lastSyncAttempt
//    }
}
