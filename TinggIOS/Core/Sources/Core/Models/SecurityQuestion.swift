//
//  SecurityQuestion.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift

// MARK: - SecurityQuestion
public class SecurityQuestion: Object,  ObjectKeyIdentifiable,  Codable {
    @Persisted public var questionID: String = ""
    @Persisted public var question: String = ""

    enum CodingKeys: String, CodingKey {
        case questionID = "QUESTION_ID"
        case question = "SECURITY_QUESTION"
    }
}
