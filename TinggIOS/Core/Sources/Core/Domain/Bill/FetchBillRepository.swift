//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation
public protocol FetchBillRepository {
    func getDueBills(tinggRequest: TinggRequest) async throws -> [FetchedBill]
}
