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
        //Public initializer
    }
    public func makeRequest<T: BaseDTOprotocol>(
        tinggRequest: TinggRequest,
        onCompletion: @escaping(Result<T, ApiError>) -> Void
    ) {
        execute(request: tinggRequest) { (result: Result<T, ApiError>) in
            onCompletion(result)
        }
    }
    
    private func execute<T: BaseDTOprotocol>(request: TinggRequest, onCompletion: @escaping(Result<T, ApiError>) -> Void) {
        call += 1
        switch request.service {
        case "FBA":
            onCompletion(executeFBACall() as! Result<T, ApiError>)
        case "UPN":
            onCompletion(executeUPNCall(request: request) as! Result<T, ApiError>)
        case .none:
            print("None")
        case .some(_):
            print("Some")
        }
       
    }
    
    private func executeFBACall() ->   Result<FetchBillDTO, ApiError>{
        let fetchBill = Invoice()
        let fetchBill2 = Invoice()
        let fetchBill3 = Invoice()
        fetchBill.dueDate = formatDateToString(date: addDaysToCurrentDate(numOfDays: 5))
        fetchBill2.dueDate = formatDateToString(date: addDaysToCurrentDate(numOfDays: 10))
        fetchBill3.dueDate = "2022-08-24 00:00:00"
        let fetchBillDTO = FetchBillDTO(statusCode: 200, statusMessage: "Successful", fetchedBills: [fetchBill, fetchBill2, fetchBill3])
        let result = Result<FetchBillDTO, ApiError>.success(fetchBillDTO)
        return result
    }
    
    private func executeUPNCall(request: TinggRequest) ->   Result<BaseDTO, ApiError>{
        let dto = BaseDTO(statusCode: 200, statusMessage: "updated preferred network for \(String(describing: request.msisdn)) to \(request.defaultNetworkServiceId)")
        let result = Result<BaseDTO, ApiError>.success(dto)
        return result
    }
}

