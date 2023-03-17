//
//  ProfileInfoDTO.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - ProfileInfo
public struct ProfileInfoDTO: Codable {
    public let profileID: Int
    public let firstName, lastName: String
    public let photoURL: String
    public let msisdn, emailAddress: String

    enum CodingKeys: String, CodingKey {
        case profileID = "PROFILE_ID"
        case firstName = "FIRST_NAME"
        case lastName = "LAST_NAME"
        case photoURL = "PHOTO_URL"
        case msisdn = "MSISDN"
        case emailAddress = "EMAIL_ADDRESS"
    }
}
