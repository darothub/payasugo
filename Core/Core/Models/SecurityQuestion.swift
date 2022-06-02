//
//  SecurityQuestion.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation

// MARK: - SecurityQuestion
public class SecurityQuestion: Identifiable,  Codable {
    public let questionID: Int
    public let securityQuestion: String

    enum CodingKeys: String, CodingKey {
        case questionID = "QUESTION_ID"
        case securityQuestion = "SECURITY_QUESTION"
    }

    init(questionID: Int, securityQuestion: String) {
        self.questionID = questionID
        self.securityQuestion = securityQuestion
    }
}
