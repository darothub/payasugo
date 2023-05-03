//
//  HomeUsecase.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
@MainActor
public class HomeUsecase {
    private var billAccountUsecase: BillAccountUsecase
    private var profileRepository: ProfileRepository
    private var merchantRepository: MerchantServiceRepository
    private var categoryRepository: CategoryRepository
    private var chunkedCategoriesUsecase: ChunkedCategoriesUsecase
    private var barChartUsecase: BarChartUsecase
    private var dueBillsUsecase: DueBillsUsecase
    private var singleDueBillUsecase: SingleDueBillUsecase
    private var saveBillUsecase: SaveBillUsecase
    private var mcpDeleteAndUpdateUsecase: MCPDeleteAndUpdateUsecase
    private var categoriesAndServicesUsecase: CategoriesAndServicesUsecase
    private var updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase
    
    /// ``HomeUsecase`` initialiser
    /// - Parameters:
    ///   - billAccountUsecase: ``BillAccountUsecase
    ///   - profileRepository: ``ProfileRepositoryImpl``
    ///   - merchantRepository: ``MerchantServiceRepositoryImpl``
    ///   - categoryRepository: ``CategoryRepositoryImpl``
    ///   - chunkedCategoriesUsecase: ``ChunkedCategoriesUsecase``
    ///   - barChartUsecase: ``BarChartUsecase``
    ///   - dueBillsUsecase: ``DueBillsUsecase``
    ///   - singleDueBillUsecase: ``SingleDueBillUsecase``
    ///   - saveBillUsecase: ``SaveBillUsecase``
    ///   - postMCPUsecase: ``PostMCPUsecase``
    ///   - categoriesAndServicesUsecase: ``CategoriesAndServicesUsecase``
    ///   - updateDefaultNetworkIdUsecase: ``UpdateDefaultNetworkUsecase``
    public init(
        billAccountUsecase: BillAccountUsecase,
        profileRepository: ProfileRepository,
        merchantRepository: MerchantServiceRepository,
        categoryRepository: CategoryRepository,
        chunkedCategoriesUsecase: ChunkedCategoriesUsecase,
        barChartUsecase: BarChartUsecase,
        dueBillsUsecase: DueBillsUsecase,
        singleDueBillUsecase: SingleDueBillUsecase,
        saveBillUsecase: SaveBillUsecase,
        mcpDeleteAndUpdateUsecase: MCPDeleteAndUpdateUsecase,
        categoriesAndServicesUsecase: CategoriesAndServicesUsecase,
        updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase

    ){
        self.billAccountUsecase = billAccountUsecase
        self.profileRepository = profileRepository
        self.merchantRepository = merchantRepository
        self.categoryRepository = categoryRepository
        self.chunkedCategoriesUsecase = chunkedCategoriesUsecase
        self.barChartUsecase = barChartUsecase
        self.dueBillsUsecase = dueBillsUsecase
        self.singleDueBillUsecase = singleDueBillUsecase
        self.saveBillUsecase = saveBillUsecase
        self.mcpDeleteAndUpdateUsecase = mcpDeleteAndUpdateUsecase
        self.categoriesAndServicesUsecase = categoriesAndServicesUsecase
        self.updateDefaultNetworkIdUsecase = updateDefaultNetworkIdUsecase
    }

    public func getProfile() -> Profile? {
        profileRepository.getProfile()
    }
    public func displayedRechargeAndBill() throws -> [MerchantService] {
        merchantRepository.getServices().prefix(8).map { service in
            service
        }
    }
    public func getQuickTopups() throws -> [MerchantService] {
        let services = merchantRepository.getServices().filter { $0.isAirtimeService }
        Log.d(message: "Services \(services)")
        return services
    }
    public func categorisedCategories() -> [[CategoryEntity]]{
        chunkedCategoriesUsecase()
    }
    
    public func getBarChartMappedData() -> [Int: Double] {
        barChartUsecase()
    }
    public func allRecharge() -> [String: [MerchantService]] {
        categoriesAndServicesUsecase()
    }
    
    public func getDueBills(billAccounts: [BillAccount]) async throws -> [Invoice] {
        var tinggRequest: TinggRequest = .shared
        tinggRequest.service = "FBA"
        tinggRequest.billAccounts = billAccounts
        return try await dueBillsUsecase(tinggRequest: tinggRequest)
    }
    public func fetchDueBills(request: RequestMap) async throws -> [Invoice] {
        return try await dueBillsUsecase(tinggRequest: request)
    }
    public func getBillAccounts() -> [BillAccount] {
        billAccountUsecase()
    }
    public func saveBill(tinggRequest: TinggRequest, invoice: Invoice) async throws -> Bill {
        let bill = try await saveBillUsecase(tinggRequest: tinggRequest)
        return  bill
    }
    public func handleMCPDeleteAndUpdateRequest(tinggRequest: TinggRequest) async throws -> BaseDTO {
        return  try await mcpDeleteAndUpdateUsecase(request: tinggRequest)
    }
    public func handleMCPRequest(tinggRequest: TinggRequest) async throws -> Bill {
        let bill = try await saveBillUsecase(tinggRequest: tinggRequest)
        return  bill
    }
    public func getSingleDueBills(tinggRequest: TinggRequest) async throws -> Invoice {
      
        return try await singleDueBillUsecase(tinggRequest: tinggRequest)
    }
    
    public func updateDefaultNetwork(request: TinggRequest) async throws -> BaseDTO {
        return try await updateDefaultNetworkIdUsecase(request: request)
    }

}

