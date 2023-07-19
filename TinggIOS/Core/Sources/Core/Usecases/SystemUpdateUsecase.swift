//
//  SystemUpdateUsecase.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//

import Foundation
public class SystemUpdateUsecase {
    public static var FSU_REFRESH_TIME = TimeInterval(3 * 60 * 60)
    public let tinggApiService: TinggApiServices
    public init(tinggApiService: TinggApiServices = BaseRequest.shared) {
        self.tinggApiService = tinggApiService
    }
    public func callAsFunction(request: RequestMap) async throws -> SystemUpdateDTO {
        try await tinggApiService.result(tinggRequest: request)
    }
}
