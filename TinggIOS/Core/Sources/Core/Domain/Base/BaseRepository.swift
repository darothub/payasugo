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
    var dbObserver: Observer<O> { get }
    
}

extension BaseRepository {
    public func getEntities() -> [O] {
        dbObserver.getEntities()
    }
    public func saveEntities(obj: O){
        dbObserver.$objects.append(obj)
    }
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

