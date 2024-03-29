//
//  FetchBillDTOswift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

// MARK: - FetchBillDTO
/// Fetch bill DTO
public struct FetchBillDTO: BaseDTOprotocol, Decodable {
    public var statusCode: Int
    public var statusMessage: String
    public var fetchedBills: [DynamicInvoiceType]
    
    /// ``FetchBillDTO`` initializer
    /// - Parameters:
    ///   - statusCode: http status code
    ///   - statusMessage: remote message
    ///   - fetchedBills: List of fetched bills
    public init(statusCode: Int, statusMessage: String, fetchedBills: [DynamicInvoiceType] = []) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.fetchedBills = fetchedBills
    }
    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case fetchedBills = "FETCHED_BILLS"
    }
}


