//
//  File.swift
//  
//
//  Created by Abdulrasaq on 02/09/2022.
//

import Foundation
import Core
class FakeBaseRequest: TinggApiServices {
    private(set) var call = 0
    init() {
        
    }
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        execute { (result: Result<T, ApiError>) in
            onCompletion(result)
        }
    }
    
    private func execute<T: BaseDTOprotocol>(onCompletion: @escaping(Result<T, ApiError>) -> Void) {
        call += 1
        let fetchBill = Invoice()
        let fetchBill2 = Invoice()
        let fetchBill3 = Invoice()
        fetchBill.dueDate = formatDateToString(date: addDaysToCurrentDate(numOfDays: 5))
        fetchBill2.dueDate = formatDateToString(date: addDaysToCurrentDate(numOfDays: 10))
        fetchBill3.dueDate = "2022-08-24 00:00:00"
        let fetchBillDTO = FetchBillDTO(statusCode: 200, statusMessage: "Successful", fetchedBills: [fetchBill, fetchBill2, fetchBill3])
        let result = Result<T, ApiError>.success(fetchBillDTO as! T)
        onCompletion(result)
    }
}

