//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation

public class DueBillsUsecase {
    private let fetchBillRepository: FetchBillRepository
    /// DueBillsUsecase initialiser
    /// - Parameter fetchBillRepository:``FetchBillRepositoryImpl`` repository for fetchbill
    public init(fetchBillRepository: FetchBillRepository) {
        self.fetchBillRepository = fetchBillRepository
    }
    
    /// A call as function to get invoices
    /// - Parameter tinggRequest: ``TinggRequest``
    /// - Returns: list of ``Invoice``
    public func callAsFunction(tinggRequest: TinggRequest) async throws -> [Invoice] {
        var dueBills = try await fetchBillRepository.getDueBills(tinggRequest: tinggRequest)
        dueBills = dueBills.filter { bill in
            let daysDiff = abs((makeDateFromString(validDateString: bill.dueDate) - Date()).day)
            return daysDiff <= 5
        }
        return dueBills
    }
}
