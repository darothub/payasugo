//
//  HomeUsecase.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
import Core

public class HomeUsecase {
    private var profileRepository: ProfileRepository
    private var merchantRepository: MerchantServiceRepository
    private var chunkedCategoriesUsecase: ChunkedCategoriesUsecase
    private var updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase
    private var systemUpdateUsecase: SystemUpdateUsecase
    
    /// ``HomeUsecase`` initialiser
    /// - Parameters:
    ///   - profileRepository: ``ProfileRepositoryImpl``
    ///   - merchantRepository: ``MerchantServiceRepositoryImpl``
    ///   - chunkedCategoriesUsecase: ``ChunkedCategoriesUsecase``
    ///   - updateDefaultNetworkIdUsecase: ``UpdateDefaultNetworkUsecase``
    ///   - systemUpdateUsecase: ``SystemUpdateUsecase``
    public init(
        profileRepository: ProfileRepository,
        merchantRepository: MerchantServiceRepository,
        chunkedCategoriesUsecase: ChunkedCategoriesUsecase,
        updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase,
        systemUpdateUsecase: SystemUpdateUsecase

    ){
        self.profileRepository = profileRepository
        self.merchantRepository = merchantRepository
        self.chunkedCategoriesUsecase = chunkedCategoriesUsecase
        self.updateDefaultNetworkIdUsecase = updateDefaultNetworkIdUsecase
        self.systemUpdateUsecase = systemUpdateUsecase
    }

    func fetchSystemUpdate(request: RequestMap)async throws -> SystemUpdateDTO {
        try await systemUpdateUsecase(request: request)
    }
    public func getProfile() -> Profile? {
        profileRepository.getProfile()
    }
    public func getQuickTopups() -> [MerchantService] {
        let services = merchantRepository.getServices().filter { $0.isAirtimeService }
        return services
    }
    public func categorisedCategories() -> [[CategoryDTO]]{
        chunkedCategoriesUsecase()
    }
    
    public func updateProfile(request: RequestMap) async throws -> BaseDTO {
        try await profileRepository.updateProfile(request: request)
    }

    public func updateDefaultNetwork(request: RequestMap) async throws -> BaseDTO {
        return try await updateDefaultNetworkIdUsecase(request: request)
    }
}

