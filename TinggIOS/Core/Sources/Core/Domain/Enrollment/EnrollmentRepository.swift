//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public protocol EnrollmentRepository {
    func getNominationInfo() -> [Enrollment]
    func saveNomination(nomination: Enrollment)
}

public class EnrollmentRepositoryImpl: EnrollmentRepository {
    private var dbObserver: Observer<Enrollment>
    public init(dbObserver: Observer<Enrollment>) {
        self.dbObserver = dbObserver
    }
    public func getNominationInfo() -> [Enrollment] {
        dbObserver.getEntities()
    }
    public func saveNomination(nomination: Enrollment) {
        dbObserver.saveEntity(obj: nomination)
    }
}
