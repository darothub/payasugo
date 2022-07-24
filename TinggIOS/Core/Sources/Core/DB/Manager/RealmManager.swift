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
            let config = Realm.Configuration(schemaVersion: 1)
            Realm.Configuration.defaultConfiguration = config
            localDb = try Realm()
        } catch {
            print("RealmManager \(error.localizedDescription)")
        }
    }
    public func addObject<S: Object>(data: Results<S>) {
        let cat: [Categorys] = [Categorys]()
        localDb?.add(cat)
        localDb?.add(data)
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
            try  localDb?.write {
                self.localDb?.add(data, update: .modified)
            }
        } catch {
            print("RealmManager save \(error.localizedDescription)")
        }
    }
}
