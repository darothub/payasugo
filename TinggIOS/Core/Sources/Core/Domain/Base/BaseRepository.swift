//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//
import RealmSwift
import Foundation
public protocol BaseRepository {
    associatedtype O where O: Object & ObjectKeyIdentifiable
    func getEntities() -> [O]
}

public protocol BassRepository {
    func getEntities<O>() -> [O]
}

public class BaseRepositoryImpl<O: Object & ObjectKeyIdentifiable>: BaseRepository {
    public var dbObserver: Observer<O>
    public init(dbObserver: Observer<O>) {
        self.dbObserver = dbObserver
    }
    public func getEntities() -> [O] {
        dbObserver.getEntities()
    }

}

