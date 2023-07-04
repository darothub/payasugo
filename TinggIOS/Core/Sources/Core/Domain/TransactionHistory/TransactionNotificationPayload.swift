//
//  NotificationPayload.swift
//  
//
//  Created by Abdulrasaq on 26/06/2023.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notificationPayload = try? JSONDecoder().decode(NotificationPayload.self, from: jsonData)

import Foundation

// MARK: - NotificationPayload
struct TransactionNotificationPayload: Codable {
    let notification: TransactionNotification
    let to, priority: String
}

// MARK: - TransactionNotification
struct TransactionNotification: Codable {
    let title: String
    let body: NotificationBody
}

// MARK: - NotificationBody
public struct NotificationBody: Codable {
    public let amount, serviceCode, billType, beepTransactionID: String
    public let source, devicePlatform, accountNumber, serviceName: String
    public let message, deviceID, customerName: String
    public let requestOriginID: Int
    public let paymentID: String
    public let invoiceNumber: String?
    public let shortDesc, installationID, serviceID, currencyCode: String
    public let overallStatus, status: String
}


