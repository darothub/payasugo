//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//
import RealmSwift
import Foundation
public class FetchBillRepositoryImpl: FetchBillRepository {
    private var baseRequest: TinggApiServices
    private var dbObserver: Observer<Invoice>
    public init(baseRequest: TinggApiServices, dbObserver: Observer<Invoice>) {
        self.baseRequest = baseRequest
        self.dbObserver = dbObserver
    }
    public func billRequest<T: BaseDTOprotocol>(tinggRequest: TinggRequest) async throws ->  T {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(tinggRequest: tinggRequest) { (result: Result<T, ApiError>) in
                continuation.resume(with: result)
            }
        }
    }
    public func getDueBills(tinggRequest: TinggRequest) async throws -> [Invoice] {
        let dto: FetchBillDTO = try await billRequest(tinggRequest: tinggRequest)
        let data = dto.fetchedBills.filter { bill in
            !bill.billDescription.contains("invalid account")
        }
        return data
    }
    
    public func saveBill(tinggRequest: TinggRequest) async throws -> SavedBill {
        let dto: SaveBillDTO = try await billRequest(tinggRequest: tinggRequest)
        let savedBill = dto.savedBill[0]
        return savedBill
    }
    
    public func insertInvoiceInDb(invoice: Invoice) {
        dbObserver.saveEntity(obj: invoice)
    }
    
}

