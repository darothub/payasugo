//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
public class HomeUsecase {
    private var billAccountUsecase: BillAccountUsecase
    private var profileRepository: ProfileRepository
    private var merchantRepository: MerchantServiceRepository
    private var categoryRepository: CategoryRepository
    private var chunkedCategoriesUsecase: ChunkedCategoriesUsecase
    private var barChartUsecase: BarChartUsecase
    private var dueBillUsecase: DueBillsUsecase

    public init(
        billAccountUsecase: BillAccountUsecase,
        profileRepository: ProfileRepository,
        merchantRepository: MerchantServiceRepository,
        categoryRepository: CategoryRepository,
        chunkedCategoriesUsecase: ChunkedCategoriesUsecase,
        barChartUsecase: BarChartUsecase,
        dueBillUsecase: DueBillsUsecase

    ){
        self.billAccountUsecase = billAccountUsecase
        self.profileRepository = profileRepository
        self.merchantRepository = merchantRepository
        self.categoryRepository = categoryRepository
        self.chunkedCategoriesUsecase = chunkedCategoriesUsecase
        self.barChartUsecase = barChartUsecase
        self.dueBillUsecase = dueBillUsecase
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
    
    public func getDueBills() async throws -> [FetchedBill] {
        var tinggRequest: TinggRequest = .shared
        tinggRequest.service = "FBA"
        tinggRequest.billAccounts = billAccountUsecase()
        print("DueBillUsecase \(tinggRequest)")
        return try await dueBillUsecase(tinggRequest: tinggRequest)
    }

}

