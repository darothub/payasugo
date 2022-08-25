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
    public func makeActivationCodeRequest(tinggRequest: TinggRequest) async throws -> Result<BaseDTO, ApiError> {
        return try await authenticateUsecase(tinggRequest: tinggRequest)
    }
    public func confirmActivationCodeRequest(tinggRequest: TinggRequest, code: String) async throws -> Result<BaseDTO, ApiError> {
        return try await authenticateUsecase(tinggRequest: tinggRequest, code: code)
    }
    public func makePARRequest(tinggRequest: TinggRequest ) async throws -> Result<PARAndFSUDTO, ApiError> {
        return try await parUsecase(tinggRequest: tinggRequest )
    }
}

public protocol OnboardingUseCase {
    func getCountryDictionary() async throws -> [String: String]
    func makeActivationCodeRequest(tinggRequest: TinggRequest) async throws -> Result<BaseDTO, ApiError>
    func confirmActivationCodeRequest(tinggRequest: TinggRequest, code: String) async throws -> Result<BaseDTO, ApiError>
    func makePARRequest(tinggRequest: TinggRequest ) async throws -> Result<PARAndFSUDTO, ApiError>
    func getCountryByDialCode(dialCode: String) -> Country?
}
