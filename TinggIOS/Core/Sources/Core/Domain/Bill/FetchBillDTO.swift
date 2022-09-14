//
//  FetchBillDTOswift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

// MARK: - FetchBillDTO
public struct FetchBillDTO: BaseDTOprotocol, Codable {
    public var statusCode: Int
    public var statusMessage: String
    public var fetchedBills: [Invoice]

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


