//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/09/2022.
//
import Core
import Foundation
import RealmSwift
import XCTest
class GetCountryByDialCodeUsecaseTest: XCTestCase {
    var countryRepository: CountryRepository!
    var getCountryByDialCodeUsecase: GetCountryByDialCodeUsecase!

    @MainActor override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        countryRepository = FakeCountryRepositoryImpl(dbObserver: Observer<CountriesInfoDTO>())
        getCountryByDialCodeUsecase = GetCountryByDialCodeUsecase(countryRepository: countryRepository)
    }
    
    func testBotswanaIsReturnedForDialCode267() async throws {
        let actual = try await getCountryByDialCodeUsecase(dialCode: "267")?.name
        let expected = "Botswana"
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
}
