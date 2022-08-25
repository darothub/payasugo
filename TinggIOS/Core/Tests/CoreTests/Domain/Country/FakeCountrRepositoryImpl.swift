//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//
import Core
import Foundation
import RealmSwift
public class FakeCountryRepositoryImpl: CountryRepository {
    @ObservedResults(Country.self) var observedDbCountries
    static let data = "{\"STATUS_CODE\":200,\"STATUS_MESSAGE\":\"Request processed Successfully\",\"COUNTRIES_INFO\":[{\"COUNTRY\":\"Botswana\",\"COUNTRY_ID\":\"30\",\"COUNTRY_CODE\":\"BW\",\"COUNTRY_URL\":\"https://kartana.tingg.africa/pci/mula_bw/api/v1/\",\"COUNTRY_DIAL_CODE\":\"267\",\"MULA_CLIENT_ID\":\"113\",\"STATUS\":\"1\",\"ALLOW_DECIMALS\":true,\"CURRENCY\":\"BWP\",\"CURRENCY_ID\":\"23\",\"CURRENCY_NAME\":\"Pula\",\"COUNTRY_URL_NEW\":\"https://kartana.tingg.africa/pci/mula_bw/api/v1/\",\"HOTLINE_APP_KEY\":\"5571ab80-4d1c-4516-b223-95831d14d1ac\",\"HOTLINE_APP_ID\":\"6a1b271f-1616-4d70-abac-dcee34482ee1\",\"FAQ_URL\":\"https://mula.co.ke/faq.html\",\"TAC_URL\":\"https://mula.co.ke/terms-of-service.php\",\"PRIVACY_POLICY_URL\":\"https://mula.co.ke/privacy-policy.php\",\"EXCLUDED_SMS_SOURCE_ADDRESSES\":[],\"COUNTRY_MOBILE_REGEX\":\"^[+]|[0-9]{8,11}$\",\"GENERIC_ACCOUNT_NUMBER_REGEX\":\"\",\"EXTRACT_SMS_ON_PROFILING\":\"\",\"COUNTRY_CURRENCY_REGEX\":\"\",\"COUNTRY_SOURCE_ADDRESSES\":\"\",\"CONFIRMED_ACCOUNT_LIMITS\":\"\",\"ALPHANUMERIC_REGEXES\":\"\",\"FRESHCHAT_APP_KEY\":\"9b82f192-a2b9-4925-a466-a998b8fd43e1\",\"FRESHCHAT_APP_ID\":\"3ada471d-9ae3-413f-943a-bd4d3f2ff197\",\"ROUND_UP_AMOUNTS\":\"NO\",\"COUNTRY_FLAG\":\"https://mula.co.ke/mula_ke/api/v1/images/flags/Botswana.png\",\"MAXIMUM_CARDS\":\"3\",\"CLEVERTAP_ACCOUNT_ID\":\"W84-RK9-645Z\",\"CLEVERTAP_TOKEN\":\"c32-4b0\",\"HAS_WALLET\":0,\"HAS_GROUPS\":0,\"HAS_FLOATING_BUTTON\":0,\"HAS_DISCOVER\":0,\"USE_SMILE_SDK\":0,\"HAS_REFERRAL\":0,\"FETCH_BEARER_TOKEN_URL\":\"https://tinggauthapi.cellulant.co.ke/tingg/api/fetchToken/\"}]}".data(using: .utf8)!
    public init() {
        //Public init
    }
    public func getCountriesAndDialCode() async throws -> [String: String] {
        let latestCountries = try await getCountries()
        let countryDictionary = latestCountries.reduce(into: [:]) { partialResult, country in
            partialResult[country.countryCode!] = country.countryDialCode
        }
        return countryDictionary
    }
    public func getCountryByDialCode(dialCode: String) -> Country? {
        let foundCountry = observedDbCountries.first(where: { country in
            country.countryDialCode == dialCode
        })
        return foundCountry
    }
    public func getCountries() async throws -> [Country] {
        let remoteCountries = getRemoteCountries().data
        let realm = try await Realm()
        // Insert from data containing JSON
        realm.writeAsync {
            realm.add(remoteCountries, update: .modified)
        }
        return remoteCountries
    }
    public func getRemoteCountries() -> CountryDTO {
        guard let countryDTO = try? JSONDecoder().decode(CountryDTO.self,from: FakeCountryRepositoryImpl.data) else {
            fatalError("Country response serialized error")
            
        }
        return countryDTO
    }
}
