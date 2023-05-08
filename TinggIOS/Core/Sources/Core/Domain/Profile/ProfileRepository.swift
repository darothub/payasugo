//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//

import Foundation
public protocol ProfileRepository {
    func getProfile() -> Profile?
    func updateProfile(request: RequestMap) async throws -> BaseDTO
}
