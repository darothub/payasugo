//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/07/2022.
//

import Foundation
public struct ProfileInfo: Codable {
    public var mulaProfile: [Profile]
    enum CodingKeys: String, CodingKey {
        case mulaProfile = "MULA_PROFILE"
    }
}
