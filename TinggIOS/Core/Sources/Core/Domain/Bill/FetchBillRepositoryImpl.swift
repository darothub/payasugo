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
    /// ``FetchBillRepositoryImpl`` initialiser
    /// - Parameters:
    ///   - baseRequest: an instance of ``BaseRequest``
    ///   - dbObserver: an instance  of ``Observer``
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
    public func billRequest<T: BaseDTOprotocol>(tinggRequest: RequestMap) async throws ->  T {
        try await baseRequest.result(tinggRequest: tinggRequest)
    }
    public func getDueBills(tinggRequest: TinggRequest) async throws -> [Invoice] {
        let dto: FetchBillDTO = try await billRequest(tinggRequest: tinggRequest)
        if dto.statusCode > 200 {
            throw ApiError.networkError(dto.statusMessage)
        }
        return dto.fetchedBills.map { $0.convertToInvoice() }
    }
    public func fetchDueBills(tinggRequest: RequestMap) async throws -> [Invoice] {
        let dto: FetchBillDTO = try await billRequest(tinggRequest: tinggRequest)
        return dto.fetchedBills.map { $0.convertToInvoice() }
    }
    
    public func saveBill(tinggRequest: TinggRequest) async throws -> Bill {
        let dto: BillDTO = try await billRequest(tinggRequest: tinggRequest)
        let savedBill = dto.savedBill[0]
        return savedBill
    }
    
    public func deleteBill(tinggRequest: TinggRequest) async throws -> BaseDTO {
        let dto: BaseDTO = try await billRequest(tinggRequest: tinggRequest)
        return dto
    }
    
    public func updateBill(tinggRequest: TinggRequest) async throws -> BaseDTO {
        let dto: BaseDTO = try await billRequest(tinggRequest: tinggRequest)
        return dto
    }
    
    public func insertInvoiceInDb(invoice: Invoice) {
        dbObserver.saveEntity(obj: invoice)
    }
    
}

public enum MCPAction: String {
    case ADD, UPDATE, DELETE
}


