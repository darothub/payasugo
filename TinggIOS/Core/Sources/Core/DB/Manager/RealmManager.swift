//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//

import Foundation
import RealmSwift
public class RealmManager: ObservableObject {
    private(set) var localDb: Realm?
    public init() {
        openRealmDb()
    }
    private func openRealmDb() {
        do {
            let config = Realm.Configuration(schemaVersion: 0)
            Realm.Configuration.defaultConfiguration = config
            localDb = try Realm()
        } catch {
            print("RealmManager \(error.localizedDescription)")
        }
    }
    public func getLocalDbConfig() -> Realm? {
        return localDb
    }
    public func save<S: Object>(data: [S]) {
        do {
            try  localDb?.write {
                self.localDb?.add(data, update: .modified)
            }
        } catch {
            print("RealmManager save \(error.localizedDescription)")
        }
    }
    public func save<S: Object>(data: S) {
        do {
            try localDb?.write {
                self.localDb?.add(data, update: .modified)
            }
        } catch {
            print("RealmManager save \(error.localizedDescription)")
        }
    }
}


public class Observer<T> where T: Object, T: ObjectKeyIdentifiable{
    @ObservedResults(T.self) public var objects
    public init() {}
}
