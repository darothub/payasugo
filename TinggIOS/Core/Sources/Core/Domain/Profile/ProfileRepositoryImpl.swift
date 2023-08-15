//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//

import Foundation
public class ProfileRepositoryImpl: ProfileRepository {
    var dbObserver: Observer<Profile>
    var baseRequest: BaseRequest
    /// ``ProfileRepositoryImpl`` initialiser
    /// - Parameter dbObserver: ``Observer``
    public init(baseRequest: BaseRequest, dbObserver: Observer<Profile>) {
        self.baseRequest = baseRequest
        self.dbObserver = dbObserver
    }
    ///  Get user profile details
    /// - Returns: ``Profile``
    public func getProfile() -> Profile? {
        return dbObserver.getEntities().first
    }
    
    public func updateProfile(request: RequestMap) async throws -> BaseDTO {
        try await baseRequest.result(request.encryptPayload()!)
    }
    
    public func updateProfileImage(request: RequestMap) async throws -> PhotoUploadResponse {
        return try await withCheckedThrowingContinuation { continuation in
            baseRequest.makeRequest(url: Utils.imageUploadUrl, method: .post, parameters: request.dict) { (result: Result<PhotoUploadResponse, ApiError>)  in
                continuation.resume(with: result)
            }
        }
    }
    public func acceptTermsAndCondition(request: RequestMap) async throws -> BaseDTO {
        try await baseRequest.result(request.encryptPayload()!)
    }
}

/// Base DTO struct for Tingg API services
public struct PhotoUploadResponse: BaseDTOprotocol {
    public var statusCode: Int
    public var statusMessage: String
    public var profilePicUrl: String
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case profilePicUrl = "profilePicUrl"
    }
}
