//
//  FetchBillRepositoryImpl.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//
import RealmSwift
import Foundation
public class FetchBillRepositoryImpl: InvoiceRepository {
    private var baseRequest: TinggApiServices
    private var dbObserver: Observer<Invoice>
    /// ``FetchBillRepositoryImpl`` initialiser
    /// - Parameters:
    ///   - baseRequest: an instance of ``BaseRequest``
    ///   - dbObserver: an instance  of ``Observer``
    public init(baseRequest: TinggApiServices = BaseRequest.shared, dbObserver: Observer<Invoice>) {
        self.baseRequest = baseRequest
        self.dbObserver = dbObserver
    }
    public func billRequest<T: BaseDTOprotocol>(tinggRequest: RequestMap) async throws ->  T {
        try await baseRequest.result(tinggRequest.encryptPayload()!)
    }
    public func getDueBills(tinggRequest: RequestMap) async throws -> FetchBillDTO {
        let dto: FetchBillDTO = try await billRequest(tinggRequest: tinggRequest)
        if dto.statusCode > 200 {
            throw ApiError.networkError(dto.statusMessage)
        }
        
        return dto
    }
    public func fetchDueBills(tinggRequest: RequestMap) async throws -> FetchBillDTO {
        let dto: FetchBillDTO = try await billRequest(tinggRequest: tinggRequest)
        if dto.statusCode > 200 {
            throw ApiError.networkError(dto.statusMessage)
        }
        
        return dto
    }
    
    public func saveBill(tinggRequest: RequestMap) async throws -> Bill {
        let dto: BillDTO = try await billRequest(tinggRequest: tinggRequest)
        let savedBill = dto.savedBill[0]
        return savedBill
    }
    
    public func deleteBill(tinggRequest: RequestMap) async throws -> BaseDTO {
        return try await updateBill(tinggRequest: tinggRequest)
    }
    
    public func updateBill(tinggRequest: RequestMap) async throws -> BaseDTO {
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


