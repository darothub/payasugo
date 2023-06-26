//
//  SystemUpdateUsecase.swift
//  
//
//  Created by Abdulrasaq on 08/05/2023.
//

import Foundation
public class SystemUpdateUsecase {
    public static var FSU_REFRESH_TIME = TimeInterval(3 * 60 * 60)
    public let sendRequest: SendRequest
    public init(sendRequest: SendRequest) {
        self.sendRequest = sendRequest
    }
    public func callAsFunction(request: RequestMap) async throws ->  Result<SystemUpdateDTO, ApiError> {
        try await sendRequest(request: request)
    }
}
