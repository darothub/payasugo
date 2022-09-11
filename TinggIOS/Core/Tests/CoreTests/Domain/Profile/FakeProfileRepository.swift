//
//  File.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//

import Foundation
import Core
import RealmSwift
class FakeProfileRepository: ProfileRepository {
    var dbObserver: Observer<Profile>
    let realm: RealmManager = .init()
    static let profileId = "newprofile"
    public init(dbObserver: Observer<Profile>) {
        self.dbObserver = dbObserver
        saveDataInDB()
    }
  
    public func getProfile() -> Profile? {
        return dbObserver.getEntities().first
    }
    
    func saveDataInDB() {
        let profile = Profile()
        profile.profileID = FakeProfileRepository.profileId
        realm.save(data: profile)
    }
}
