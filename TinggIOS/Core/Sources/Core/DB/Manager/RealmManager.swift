//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//

import Foundation
import RealmSwift
import SwiftUI
///  Class for managing Realm database
public final class RealmManager: ObservableObject {
    private(set) var localDb: Realm?
    public init() {
        openRealmDb()
    }
    public convenience init(localDb: Realm?) {
        self.init()
        self.localDb = localDb
    }
    private func openRealmDb() {
        do {
            var config = Realm.Configuration(schemaVersion: 2)
            config.deleteRealmIfMigrationNeeded = true
            Realm.Configuration.defaultConfiguration = config
            localDb = try Realm()
        } catch {
            print("RealmManager \(error.localizedDescription)")
        }
    }
    public func getLocalDbConfig() -> Realm? {
        return localDb
    }
    public func save<S>(data: [S]) where S: Object {
        do {
            try  localDb?.write {
                self.localDb?.add(data, update: .modified)
            }
        } catch {
            print("RealmManager save \(error.localizedDescription)")
        }
    }
    public func save<S>(data: S) where S: Object {
        do {
            try localDb?.write {
                self.localDb?.add(data, update: .modified)
            }
        } catch {
            print("RealmManager save \(error.localizedDescription)")
        }
    }
    public func invalidate() {
        do {
            try  localDb?.write { [unowned self] in
                localDb?.deleteAll()
            }
        } catch {
            print("RealmManager save \(error.localizedDescription)")
        }
        
    }
}

/// Class for observing real time data changes from realm database
public class Observer<T> where T: Object, T: ObjectKeyIdentifiable {
    @ObservedResults(T.self) public var objects
    var realmManager: RealmManager = .init()
    public init() {
        //public initializer
    }
    
    public func getEntities() ->[T] {
        objects.map(returnEntity(obj:))
    }
    
    public func saveEntity(obj: T){
        realmManager.save(data: obj)
    }
    public func saveEntities(objs: [T]){
        realmManager.save(data: objs)
    }
    private func returnEntity(obj: T) -> T {
        return obj
    }
}

public protocol DBObject: Object {}

public struct RealmManagerKey: EnvironmentKey {
    public static let defaultValue: RealmManager = RealmManager()
}

public extension EnvironmentValues {
    var realmManager: RealmManager {
        get { self[RealmManagerKey.self] }
        set { self[RealmManagerKey.self] = newValue }
    }
}

extension View {
    public func realmManager(_ realmManager: RealmManager) -> some View {
        environment(\.realmManager, realmManager)
    }
}
