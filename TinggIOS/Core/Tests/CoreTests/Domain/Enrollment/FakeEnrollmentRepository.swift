//
//  File.swift
//  
//
//  Created by Abdulrasaq on 11/09/2022.
//

import Foundation
import Core
import RealmSwift
class FakeEnrollmentRepository: EnrollmentRepository {
    var dbObserver: Observer<Enrollment>
//    let realm: RealmManager = .init()
    public init(dbObserver: Observer<Enrollment>) {
        self.dbObserver = dbObserver
        saveDataInDB()
    }
    public func getNominationInfo() -> [Enrollment] {
        dbObserver.getEntities()
    }
    func saveDataInDB() {
        let enrollment1 = Enrollment()
        enrollment1.hubServiceID = 1
        enrollment1.accountNumber = "123"
        let enrollment2 = Enrollment()
        enrollment2.hubServiceID = 2
        enrollment2.accountNumber = "456"
        let enrollment3 = Enrollment()
        enrollment3.hubServiceID = 3
        enrollment3.accountNumber = "789"
        [enrollment1, enrollment2, enrollment3].forEach { info in
            saveNomination(nomination: info)
        }
    }
    
    func saveNomination(nomination: Core.Enrollment) {
        dbObserver.saveEntity(obj: nomination)
    }
}
