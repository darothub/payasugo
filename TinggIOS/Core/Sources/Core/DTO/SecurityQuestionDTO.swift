//
//  SecurityQuestionDTO.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - SecurityQuestion
public struct SecurityQuestionDTO: Codable {
    public let questionID, securityQuestion: String

    enum CodingKeys: String, CodingKey {
        case questionID = "QUESTION_ID"
        case securityQuestion = "SECURITY_QUESTION"
    }
    public var toEntity: SecurityQuestion {
        var entity = SecurityQuestion()
        entity.questionID = self.questionID
        entity.question = self.securityQuestion
        return entity
    }
}
