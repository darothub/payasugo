//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
public class HomeUsecase {
    private var fetchDueBillRepository: FetchBillRepository
    private var profileRepository: ProfileRepository
    private var merchantRepository: MerchantServiceRepository
    private var categoryRepository: CategoryRepository
    private var chunkedCategoriesUsecase: ChunkedCategoriesUsecase
    private var barChartUsecase: BarChartUsecase
    private var dueBillsUsecase: DueBillsUsecase
    public init(
        fetchDueBillRepository: FetchBillRepository,
        profileRepository: ProfileRepository,
        merchantRepository: MerchantServiceRepository,
        categoryRepository: CategoryRepository,
        chunkedCategoriesUsecase: ChunkedCategoriesUsecase,
        barChartUsecase: BarChartUsecase,
        dueBillsUsecase: DueBillsUsecase

    ){
        self.fetchDueBillRepository = fetchDueBillRepository
        self.profileRepository = profileRepository
        self.merchantRepository = merchantRepository
        self.categoryRepository = categoryRepository
        self.chunkedCategoriesUsecase = chunkedCategoriesUsecase
        self.barChartUsecase = barChartUsecase
        self.dueBillsUsecase = dueBillsUsecase
    }
    public func fetchDueBill(tinggRequest: TinggRequest) async throws -> [FetchedBill] {
        return try await fetchDueBillRepository.getDueBills(tinggRequest: tinggRequest)
    }
    public func getProfile() -> Profile? {
        profileRepository.getProfile()
    }
    public func displayedRechargeAndBill() -> [MerchantService] {
        merchantRepository.getServices().prefix(8).shuffled()
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
    
    public func getDueBills() async throws -> [FetchedBill] {
       try await dueBillsUsecase()
    }

}

