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
    /// ``EnrollmentRepositoryImpl`` initialiser
    /// - Parameter dbObserver: ``Observer``
    public init(dbObserver: Observer<Enrollment>) {
        self.dbObserver = dbObserver
    }
    /// A method to get enrollment/nomination info
    /// - Returns: a list of  ``Enrollment``
    public func getNominationInfo() -> [Enrollment] {
        dbObserver.getEntities()
    }
    /// Saves ``Enrollment``
    /// - Parameter nomination: an instance of  ``Enrollment``
    public func saveNomination(nomination: Enrollment) {
        dbObserver.saveEntity(obj: nomination)
    }
}
