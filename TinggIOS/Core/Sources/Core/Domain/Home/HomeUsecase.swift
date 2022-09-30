//
//  File.swift
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
    private var postMCPUsecase: PostMCPUsecase
    private var allRechargeUsecase: AllRechargeUsecase
    private var updateDefaultNetworkIdUsecase: UpdateDefaultNetworkUsecase

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
        postMCPUsecase: PostMCPUsecase,
        allRechargeUsecase: AllRechargeUsecase,
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
        self.postMCPUsecase = postMCPUsecase
        self.allRechargeUsecase = allRechargeUsecase
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
    public func getQuickTopups()throws -> [MerchantService] {
        let categories = categoryRepository.getCategories()
        let airtimes = categories.filter {$0.categoryName == "Airtime"}
        if !airtimes.isEmpty {
            let theAirtimeCategory = airtimes[0]
            return merchantRepository.getServices().filter { $0.categoryID == theAirtimeCategory.categoryID}
        } else {
            throw "No Airtime category"
        }
    }
    public func categorisedCategories() -> [[Categorys]]{
        chunkedCategoriesUsecase()
    }
    
    public func getBarChartMappedData() -> [Int: Double] {
        barChartUsecase()
    }
    public func allRecharge() -> [String: [MerchantService]] {
        allRechargeUsecase()
    }
    
    public func getDueBills() async throws -> [Invoice] {
        var tinggRequest: TinggRequest = .shared
        tinggRequest.service = "FBA"
        tinggRequest.billAccounts = billAccountUsecase()
//        print("DueBillUsecase \(tinggRequest)")
        return try await dueBillsUsecase(tinggRequest: tinggRequest)
    }
    
    public func saveBill(tinggRequest: TinggRequest, invoice: Invoice) async throws -> SavedBill {
        let bill = try await saveBillUsecase(tinggRequest: tinggRequest)
        return  postMCPUsecase(bill: bill, invoice: invoice)
    }
    
    public func getSingleDueBills(accountNumber: String, serviceId: String) async throws -> Invoice {
        var tinggRequest: TinggRequest = .init()
        tinggRequest.service = "FB"
        tinggRequest.accountNumber = accountNumber
        tinggRequest.serviceId = serviceId
        return try await singleDueBillUsecase(tinggRequest: tinggRequest)
    }
    
    public func updateDefaultNetwork(request: TinggRequest) async throws -> BaseDTO {
        return try await updateDefaultNetworkIdUsecase(request: request)
    }

}

