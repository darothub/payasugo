//
//  File.swift
//  
//
//  Created by Abdulrasaq on 25/01/2023.
//

import Foundation
public struct CreateCardChannelResponse: BaseDTOprotocol, Hashable {
    public var statusCode: Int
    public var statusMessage: String
    public var beepTransactionId: String
    public var paymentToken: String? = ""
    public var requestLogId: String
    public var amount: Double = 0.0
    public var webUrl: String
    public var serviceId: String
    public var serviceName: String
    public var serviceCode: String
    public var successUrl: String
    
    public init(statusCode: Int = 0, statusMessage: String = "", beepTransactionId: String = "", paymentToken: String? = "", requestLogId: String="", amount: Double=0.0, webUrl: String = "", serviceId: String="", serviceName: String="", serviceCode: String="", successUrl: String="") {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.beepTransactionId = beepTransactionId
        self.paymentToken = paymentToken
        self.requestLogId = requestLogId
        self.amount = amount
        self.webUrl = webUrl
        self.serviceId = serviceId
        self.serviceName = serviceName
        self.serviceCode = serviceCode
        self.successUrl = successUrl
    }
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case beepTransactionId = "BEEP_TRANSACTION_ID"
        case paymentToken = "PAYMENT_TOKEN"
        case requestLogId = "REQUEST_LOG_ID"
        case amount = "AMOUNT"
        case webUrl = "WEB_URL"
        case serviceId = "SERVICE_ID"
        case serviceName = "SERVICE_NAME"
        case serviceCode = "SERVICE_CODE"
        case successUrl = "SUCCESS_URL"
    }
}
