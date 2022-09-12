//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public class BillAccountUsecase {
    private let merchantServiceRepository: MerchantServiceRepository
    private let enrollmentRepository: EnrollmentRepository
    
    public init(
        merchantServiceRepository: MerchantServiceRepository,
        enrollmentRepository: EnrollmentRepository
    ){
        self.enrollmentRepository = enrollmentRepository
        self.merchantServiceRepository = merchantServiceRepository
    }
    
    public func callAsFunction() -> [BillAccount] {
        let enrollments =  merchantServiceRepository.getServices().flatMap { service in
            enrollmentRepository.getNominationInfo().filter { enrollment  in
                (String(enrollment.hubServiceID) == service.hubServiceID)  && service.presentmentType != "hasNone"
            }
        }
        print("Nomination \(enrollments)")
        let billAccounts = enrollments.map { nominationInfo -> BillAccount in
           return BillAccount(serviceId:String( nominationInfo.hubServiceID), accountNumber: String(nominationInfo.accountNumber!))
        }
        return billAccounts
    }
}