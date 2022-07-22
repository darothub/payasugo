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
    @Persisted(primaryKey: true) public var questionID: ObjectId
    @Persisted public var securityQuestion: String = ""

    enum CodingKeys: String, CodingKey {
        case questionID = "QUESTION_ID"
        case securityQuestion = "SECURITY_QUESTION"
    }

//    init(securityQuestion: String) {
//        self.securityQuestion = securityQuestion
//    }
}
