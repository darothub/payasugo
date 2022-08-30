//
//  FetchBillDTOswift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

// MARK: - FetchBillDTO
public struct FetchBillDTO: BaseDTOprotocol, Codable {
    public let statusCode: Int
    public let statusMessage: String
    public let fetchedBills: [FetchedBill]

    enum CodingKeys: String, CodingKey {
        case statusCode = "STATUS_CODE"
        case statusMessage = "STATUS_MESSAGE"
        case fetchedBills = "FETCHED_BILLS"
    }
}
