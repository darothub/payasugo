//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
public class HomeUsecaseImpl: HomeUsecase {
    var fetchDueBillUsecase: FetchDueBillUsecase
    public init(fetchDueBillUsecase: FetchDueBillUsecase){
        self.fetchDueBillUsecase = fetchDueBillUsecase
    }
    public func fetchDueBill(tinggRequest: TinggRequest) async throws -> [FetchedBill] {
        return try await fetchDueBillUsecase(tinggRequest: tinggRequest)
    }
}



public protocol HomeUsecase {
    func fetchDueBill(tinggRequest: TinggRequest) async throws -> [FetchedBill]
}
