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
    let activationRepository: ActivationRepository
    let parAndFsuRepository: PARAndFSURepository
    /// ``OnboardingUseCase`` intialiser
    /// - Parameters:
    ///   - getCountriesAndDialCodeUsecase: ``GetCountryByDialCodeUsecase``
    ///   - getCountryByDialCodeUsecase: ``GetCountryByDialCodeUsecase``
    ///   - activationRepository: ``ActivationRepositoryImpl``
    ///   - parAndFsuRepository: ``PARAndFSURepositoryImpl``
    public init (
        getCountriesAndDialCodeUsecase: GetCountriesAndDialCodeUseCase,
        getCountryByDialCodeUsecase: GetCountryByDialCodeUsecase,
        activationRepository: ActivationRepository,
        parAndFsuRepository: PARAndFSURepository
    ) {
        self.getCountriesAndDialCodeUsecase = getCountriesAndDialCodeUsecase
        self.getCountryByDialCodeUsecase = getCountryByDialCodeUsecase
        self.activationRepository = activationRepository
        self.parAndFsuRepository = parAndFsuRepository
    }
    
    /// Method to get a dictionary of ``Country`` and ``Country/countryDialCode``
    /// - Returns: a dictionary
    /// ```swift
    /// ["KE":"Kenya"]
    /// ```
    public func getCountryDictionary() async throws -> [String: String] {
        return try await getCountriesAndDialCodeUsecase()
    }
    /// Method to get country by dial code
    /// - Parameter dialCode: ``Country/countryDialCode``
    /// - Returns: ``Country`` if the country exist
    public func getCountryByDialCode(dialCode: String) async throws -> Country? {
        return try await getCountryByDialCodeUsecase(dialCode: dialCode)
    }
    /// Request for activation code
    /// - Parameter tinggRequest: MAK request
    /// - Returns: Result with ``BaseDTO`` or ``ApiError``
    public func makeActivationCodeRequest(tinggRequest: RequestMap) async throws -> Result<BaseDTO, ApiError> {
        return try await activationRepository.requestForActivationCode(tinggRequest: tinggRequest)
    }
    /// Request to confirm activation code
    /// - Parameters:
    ///   - tinggRequest: VAK request
    ///   - code: OTP
    /// - Returns: Result with ``BaseDTO`` or ``ApiError``
    public func confirmActivationCodeRequest(tinggRequest: RequestMap, code: String) async throws -> Result<BaseDTO, ApiError> {
        return try await activationRepository.confirmActivationCode(tinggRequest: tinggRequest, code: code)
    }
    public func makePARRequest(tinggRequest: RequestMap ) async throws -> Result<FSUAndPARDTO, ApiError> {
        return try await parAndFsuRepository.makeParAndFsuRequest(tinggRequest: tinggRequest)
    }
}

