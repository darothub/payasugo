//
//  SMSTemplate.swift
//  Core
//
//  Created by Abdulrasaq on 02/06/2022.
//

import Foundation
// MARK: - SMSTemplate
public class SMSTemplate:Identifiable, Codable {
    public let id: Int
    public let template, regex, serviceID, serviceCode: String?
    public let clientID, countryID, regexType, sourceAddress: String?
    public let keywords, mappingValues, messageType, accountNumberRegex: String?
    public let parseType, serviceCategoryID, service: String?
    public let isContracted: Bool
    public let accountSanitizerRegex, smsTemplateType, associativeSourceAddress: String?

    enum CodingKeys: String, CodingKey {
        case id, template
        case regex = "REGEX"
        case serviceID = "SERVICE_ID"
        case serviceCode = "SERVICE_CODE"
        case clientID = "CLIENT_ID"
        case countryID = "COUNTRY_ID"
        case regexType = "REGEX_TYPE"
        case sourceAddress = "SOURCE_ADDRESS"
        case keywords = "KEYWORDS"
        case mappingValues = "MAPPING_VALUES"
        case messageType = "MESSAGE_TYPE"
        case accountNumberRegex = "ACCOUNT_NUMBER_REGEX"
        case parseType = "PARSE_TYPE"
        case serviceCategoryID = "SERVICE_CATEGORY_ID"
        case service = "SERVICE"
        case isContracted = "IS_CONTRACTED"
        case accountSanitizerRegex = "ACCOUNT_SANITIZER_REGEX"
        case smsTemplateType = "SMS_TEMPLATE_TYPE"
        case associativeSourceAddress = "ASSOCIATIVE_SOURCE_ADDRESS"
    }

    init(id: Int, template: String?, regex: String?, serviceID: String?, serviceCode: String?, clientID: String?, countryID: String?, regexType: String?, sourceAddress: String?, keywords: String?, mappingValues: String?, messageType: String?, accountNumberRegex: String?, parseType: String?, serviceCategoryID: String?, service: String?, isContracted: Bool, accountSanitizerRegex: String?, smsTemplateType: String?, associativeSourceAddress: String?) {
        self.id = 0
        self.template = template
        self.regex = regex
        self.serviceID = serviceID
        self.serviceCode = serviceCode
        self.clientID = clientID
        self.countryID = countryID
        self.regexType = regexType
        self.sourceAddress = sourceAddress
        self.keywords = keywords
        self.mappingValues = mappingValues
        self.messageType = messageType
        self.accountNumberRegex = accountNumberRegex
        self.parseType = parseType
        self.serviceCategoryID = serviceCategoryID
        self.service = service
        self.isContracted = isContracted
        self.accountSanitizerRegex = accountSanitizerRegex
        self.smsTemplateType = smsTemplateType
        self.associativeSourceAddress = associativeSourceAddress
    }
}
