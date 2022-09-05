//
//  File.swift
//  
//
//  Created by Abdulrasaq on 23/08/2022.
//

import Foundation

public class OnboardingUseCase {
    let getCountriesAndDialCodeUsecase: GetCountriesAndDialCodeUseCase
    let getCountryByDialCodeUsecase: GetCountryByDialCodeUsecase
    let authenticateRepository: AuthenticateRepository
    let parAndFsuRepository: PARAndFSURepository
    public init (
        getCountriesAndDialCodeUsecase: GetCountriesAndDialCodeUseCase,
        getCountryByDialCodeUsecase: GetCountryByDialCodeUsecase,
        authenticateRepository: AuthenticateRepository,
        parAndFsuRepository: PARAndFSURepository
    ) {
        self.getCountriesAndDialCodeUsecase = getCountriesAndDialCodeUsecase
        self.getCountryByDialCodeUsecase = getCountryByDialCodeUsecase
        self.authenticateRepository = authenticateRepository
        self.parAndFsuRepository = parAndFsuRepository
    }
    
    public func getCountryDictionary() async throws -> [String: String] {
        return try await getCountriesAndDialCodeUsecase()
    }
    public func getCountryByDialCode(dialCode: String) async throws -> Country? {
        return try await getCountryByDialCodeUsecase(dialCode: dialCode)
    }
    public func makeActivationCodeRequest(tinggRequest: TinggRequest) async throws -> Result<BaseDTO, ApiError> {
        return try await authenticateRepository.requestForActivationCode(tinggRequest: tinggRequest)
    }
    public func confirmActivationCodeRequest(tinggRequest: TinggRequest, code: String) async throws -> Result<BaseDTO, ApiError> {
        return try await authenticateRepository.confirmActivationCode(tinggRequest: tinggRequest, code: code)
    }
    public func makePARRequest(tinggRequest: TinggRequest ) async throws -> Result<PARAndFSUDTO, ApiError> {
        return try await parAndFsuRepository.makeParAndFsuRequest(tinggRequest: tinggRequest)
    }
}

