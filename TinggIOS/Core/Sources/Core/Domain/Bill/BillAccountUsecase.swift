//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
/// Bill account use case
public class BillAccountUsecase {
    private let merchantServiceRepository: MerchantServiceRepository
    private let enrollmentRepository: EnrollmentRepository
    
    /// Bill account use case initializer
    /// - Parameters:
    ///   - merchantServiceRepository: ``MerchantServiceRepositoryImpl``repository for mechant services
    ///   - enrollmentRepository: ``EnrollmentRepositoryImpl``repository for enrollment/nomination info
    public init(
        merchantServiceRepository: MerchantServiceRepository,
        enrollmentRepository: EnrollmentRepository
    ){
        self.enrollmentRepository = enrollmentRepository
        self.merchantServiceRepository = merchantServiceRepository
    }
    
    /// A call as function to get list of bill accounts
    /// - Returns: list of ``BillAccount``
    public func callAsFunction() -> [BillAccount] {
        let enrollments =  merchantServiceRepository.getServices().flatMap { service in
            enrollmentRepository.getNominationInfo().filter { enrollment  in
                (String(enrollment.hubServiceID) == service.hubServiceID)  && service.presentmentType != "hasNone"
            }
        }
        let billAccounts = enrollments.map { nominationInfo -> BillAccount in
           return BillAccount(serviceId:String( nominationInfo.hubServiceID), accountNumber: String(nominationInfo.accountNumber!))
        }
        return billAccounts
    }
}
