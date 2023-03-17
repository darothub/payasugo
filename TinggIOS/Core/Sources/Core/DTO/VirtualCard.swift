//
//  File.swift
//  
//
//  Created by Abdulrasaq on 14/03/2023.
//

import Foundation
// MARK: - VirtualCard
public struct VirtualCard: Codable {
    public let cardAlias, activeStatus: String

    enum CodingKeys: String, CodingKey {
        case cardAlias = "CARD_ALIAS"
        case activeStatus = "ACTIVE_STATUS"
    }
    public var toEntity: Card {
        var entity = Card()
        entity.cardAlias = self.cardAlias
        entity.activeStatus = self.activeStatus
        return entity
    }
}
// MARK: - CardDetail
public struct CardDetailDTO: Hashable, Equatable {
    public var cardAlias, payerClientID, cardType, activeStatus, logoUrl: String
    public init(cardAlias: String, payerClientID: String, cardType: String, activeStatus: String, logoUrl: String) {
        self.cardAlias = cardAlias
        self.payerClientID = payerClientID
        self.cardType = cardType
        self.activeStatus = activeStatus
        self.logoUrl = logoUrl
    }
   
}
public var sampleCardDTO = CardDetailDTO(cardAlias: "0000", payerClientID: "162", cardType: "002", activeStatus: "1", logoUrl: "")
public var sampleCardDTO2 = CardDetailDTO(cardAlias: "0002", payerClientID: "162", cardType: "002", activeStatus: "1", logoUrl: "")
public var sampleCardDTO3 = CardDetailDTO(cardAlias: "0003", payerClientID: "162", cardType: "002", activeStatus: "1", logoUrl: "")
