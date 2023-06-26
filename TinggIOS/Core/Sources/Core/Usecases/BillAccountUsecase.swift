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
        let services = merchantServiceRepository.getServices()
        let nominations = enrollmentRepository.getNominationInfo()

        let billAccounts = nominations.compactMap { nomination in
           let service = services.first { service in
               String(nomination.hubServiceID) == service.hubServiceID && (PresentmentType(rawValue: service.presentmentType) == PresentmentType.hasPresentment) && nomination.isExplicit
            }
            if let service = service {
                return BillAccount(serviceId:String(service.hubServiceID), accountNumber: String(nomination.accountNumber))
            }
            return nil
        }
        
        return billAccounts
    }
}
