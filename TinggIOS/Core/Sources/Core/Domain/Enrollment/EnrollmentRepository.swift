//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public protocol EnrollmentRepository {
    func getNominationInfo() -> [Enrollment]
}

public class EnrollmentRepositoryImpl: EnrollmentRepository {
    var dbObserver: Observer<Enrollment>
    public init(dbObserver: Observer<Enrollment>) {
        self.dbObserver = dbObserver
    }
    public func getNominationInfo() -> [Enrollment] {
        dbObserver.getEntities()
    }
}
