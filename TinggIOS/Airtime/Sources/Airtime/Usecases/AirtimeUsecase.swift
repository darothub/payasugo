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
        let services = merchantRepository.getServices().filter { $0.isAirtimeService }
        Log.d(message: "Services \(services)")
        return services
    }
    
    public func updateDefaultNetwork(request: TinggRequest) async throws -> BaseDTO {
        return try await updateDefaultNetworkIdUsecase(request: request)
    }

}
