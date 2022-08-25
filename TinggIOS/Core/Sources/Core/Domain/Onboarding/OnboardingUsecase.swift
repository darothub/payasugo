//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation

public class OnboardingUsecaseImpl: OnboardingUseCase {
    let getCountriesUsecase: GetCountriesUsecase
    let authenticateUsecase: AuthenticateUsecase
    let parUsecase: PARAndFSUUsecase
    public init (getCountriesUsecase: GetCountriesUsecase, authenticateUsecase: AuthenticateUsecase, parUsecase: PARAndFSUUsecase) {
        self.getCountriesUsecase = getCountriesUsecase
        self.authenticateUsecase = authenticateUsecase
        self.parUsecase = parUsecase
    }
    
    public func getCountryDictionary() async throws -> [String: String] {
        return try await getCountriesUsecase()
    }
    public func getCountryByDialCode(dialCode: String) -> Country? {
        return getCountriesUsecase(dialCode: dialCode)
    }
    public func makeActivationCodeRequest(msisdn: String, clientId: String) async throws -> Result<BaseDTO, ApiError> {
        return try await authenticateUsecase(msisdn: msisdn, clientId: clientId)
    }
    public func confirmActivationCodeRequest(msisdn: String, clientId: String, code: String) async throws -> Result<BaseDTO, ApiError> {
        return try await authenticateUsecase(msisdn: msisdn, clientId: clientId, code: code)
    }
    public func makePARRequest(msisdn: String, clientId: String) async throws -> Result<PARAndFSUDTO, ApiError> {
        return try await parUsecase(msisdn: msisdn, clientId: clientId)
    }
}

public protocol OnboardingUseCase {
    func getCountryDictionary() async throws -> [String: String]
    func makeActivationCodeRequest(msisdn: String, clientId: String) async throws -> Result<BaseDTO, ApiError>
    func confirmActivationCodeRequest(msisdn: String, clientId: String, code: String) async throws -> Result<BaseDTO, ApiError>
    func makePARRequest(msisdn: String, clientId: String) async throws -> Result<PARAndFSUDTO, ApiError>
    func getCountryByDialCode(dialCode: String) -> Country?
}
