//
//  ReferralInvite.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift

// MARK: - ReferralInvite
public class ReferralInvite: Object,  ObjectKeyIdentifiable, Codable {
    @Persisted(primaryKey: true) public var inviteID: ObjectId
    @Persisted public var invitedMSISDN: String? = ""
    @Persisted public var invitedName: String? = ""
    @Persisted public var status: Int = 0

    enum CodingKeys: String, CodingKey {
        case inviteID, invitedMSISDN, invitedName, status
    }

//    init(invitedMSISDN: String?, invitedName: String?, status: Int) {
//        self.invitedMSISDN = invitedMSISDN
//        self.invitedName = invitedName
//        self.status = status
//    }
}
