//
//  File.swift
//  
//
//  Created by Abdulrasaq on 27/01/2023.
//
import Core
import Foundation
public class AirtimeUsecase {
    private var profileRepository: ProfileRepository
    private var merchantRepository: MerchantServiceRepository
    private var categoryRepository: CategoryRepository
    private var updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase
    
    /// ``AirtimeUsecase`` initialiser
    /// - Parameters:
    ///   - profileRepository: ``ProfileRepositoryImpl``
    ///   - merchantRepository: ``MerchantServiceRepositoryImpl``
    ///   - categoryRepository: ``CategoryRepositoryImpl``
    ///   - updateDefaultNetworkIdUsecase: ``UpdateDefaultNetworkUsecase``
    public init(
        profileRepository: ProfileRepository,
        merchantRepository: MerchantServiceRepository,
        categoryRepository: CategoryRepository,
        updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase

    ){
        self.profileRepository = profileRepository
        self.merchantRepository = merchantRepository
        self.categoryRepository = categoryRepository
        self.updateDefaultNetworkIdUsecase = updateDefaultNetworkIdUsecase
    }

    public func getProfile() -> Profile? {
        profileRepository.getProfile()
    }
    public func getQuickTopups() throws -> [MerchantService] {
        let categories = categoryRepository.getCategories()
        let airtimes = categories.filter {$0.categoryName == "Airtime"}
        if !airtimes.isEmpty {
            let theAirtimeCategory = airtimes[0]
            return merchantRepository.getServices().filter { $0.categoryID == theAirtimeCategory.categoryID}
        } else {
            throw "No Airtime category"
        }
    }
    
    public func updateDefaultNetwork(request: TinggRequest) async throws -> BaseDTO {
        return try await updateDefaultNetworkIdUsecase(request: request)
    }

}
