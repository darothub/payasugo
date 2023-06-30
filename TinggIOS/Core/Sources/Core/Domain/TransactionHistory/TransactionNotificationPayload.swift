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
struct NotificationBody: Codable {
    let amount, serviceCode, billType, beepTransactionID: String
    let source, devicePlatform, accountNumber, serviceName: String
    let message, deviceID, customerName: String
    let requestOriginID: Int
    let paymentID: String
    let invoiceNumber: JSONNull?
    let shortDesc, installationID, serviceID, currencyCode: String
    let overallStatus, status: String
}


