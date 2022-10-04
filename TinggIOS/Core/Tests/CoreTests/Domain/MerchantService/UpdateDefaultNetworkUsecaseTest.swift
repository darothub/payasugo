//
//  UpdateDefaultNetworkUsecase.swift
//  
//
//  Created by Abdulrasaq on 30/09/2022.
//
import Core
import XCTest

final class UpdateDefaultNetworkUsecaseTest: XCTestCase {
    private var usecase: UpdateDefaultNetworkUsecase!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        usecase = UpdateDefaultNetworkUsecase(baseRequest: FakeBaseRequest())
    }

    func testUpdateDefaultNetworkUsecase() async throws  {
        var request = TinggRequest()
        request.msisdn = "+254722777890"
        request.defaultNetworkServiceId = "ke.orange"
        request.service = "UPN"
        let dto = try await usecase(request: request)
        let expected = "updated preferred network for \(String(describing: request.msisdn)) to \(request.defaultNetworkServiceId)"
        let actual = dto.statusMessage
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
}
