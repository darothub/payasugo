//
//  MCPUsecaseImpl.swift
//  
//
//  Created by Abdulrasaq on 05/07/2023.
//
import Core
import Foundation
protocol MCPUsecase {
    func callAsFunction<T: BaseDTOprotocol>(request: RequestMap) async throws -> T
}

class MCPUsecaseImpl: MCPUsecase {
    let tinggApiService: TinggApiServices
    init(tinggApiService: TinggApiServices = BaseRequest.shared) {
        self.tinggApiService = tinggApiService
    }
    func callAsFunction<T: BaseDTOprotocol>(request: Core.RequestMap) async throws -> T {
        try await tinggApiService.result(request.encryptPayload()!)
    }
}
