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
    public func callAsFunction(tinggRequest: RequestMap) async throws -> [Invoice] {
        var dueBills = try await fetchBillRepository.fetchDueBills(tinggRequest: tinggRequest)
        dueBills = dueBills.filter { bill in
            Log.d(message: "\(bill.dueDate)")
            let daysDiff = (makeDateFromString(validDateString: bill.dueDate) - Date()).day
            Log.d(message: "\(daysDiff)")
            let yearsDiff = (makeDateFromString(validDateString: bill.dueDate) - Date()).year
            Log.d(message: "\(yearsDiff)")
            return daysDiff <= -1 && yearsDiff <= 5
        }
        return dueBills
    }
}
