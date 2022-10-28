//
//  FetchBillDTOswift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

// MARK: - FetchBillDTO
/// Fetch bill DTO
public struct FetchBillDTO: BaseDTOprotocol, Codable {
    public var statusCode: Int
    public var statusMessage: String
    public var fetchedBills: [Invoice]
    
    /// ``FetchBillDTO`` initializer
    /// - Parameters:
    ///   - statusCode: http status code
    ///   - statusMessage: remote message
    ///   - fetchedBills: List of fetched bills
    public init(statusCode: Int, statusMessage: String, fetchedBills: [Invoice]) {
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


