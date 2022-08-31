//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//

import Foundation
public class ProfileRepositoryImpl: ProfileRepository {
    var dbObserver: Observer<Profile>
    public init(dbObserver: Observer<Profile>) {
        self.dbObserver = dbObserver
    }
    public func getProfile() -> Profile? {
        return dbObserver.getEntities().first
    }
}
