//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public class DueBillsUsecase {
    private let billAccountUseCase: BillAccountUsecase
    private let fetchBillRepository: FetchBillRepository
    
    public init(billAccountUseCase: BillAccountUsecase, fetchBillRepository: FetchBillRepository) {
        self.fetchBillRepository = fetchBillRepository
        self.billAccountUseCase = billAccountUseCase
    }
    
    func callAsFunction() async throws -> [FetchedBill] {
        var tinggRequest: TinggRequest = .shared
        tinggRequest.service = "FBA"
        tinggRequest.billAccounts = billAccountUseCase()
        print("DueBillUsecase \(tinggRequest)")
        var dueBills = try await fetchBillRepository.getDueBills(tinggRequest: tinggRequest)
        dueBills = dueBills.filter { bill in
            let daysDiff = abs((makeDateFromString(validDateString: bill.dueDate) - Date()).day)
            return daysDiff <= 5
        }
        return dueBills
    }
}
