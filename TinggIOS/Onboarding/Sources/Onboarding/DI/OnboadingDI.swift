//
//  File.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
import Core

public struct OnboardingDI {
    public init() {
        //public init
    }
    public static func createRealmManager() -> RealmManager {
        return RealmManager()
    }
    public static func createBaseRequest() -> BaseRequest {
        return .init()
    }
    public static func createCountryRepository() -> CountryRepositoryImpl {
        return CountryRepositoryImpl(
            baseRequest: createBaseRequest(),
            realmManager: createRealmManager()
        )
    }
    @MainActor
    public static func createOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(onboardingUseCase: createOnboardingUseCase())
    }
    public static func createOnboardingUseCase() -> OnboardingUseCase {
        return OnboardingUsecaseImpl(
            getCountriesUsecase: createGetCountriesUsecase(),
            authenticateUsecase: createAuthenticateUsecase(),
            parUsecase: createParAndFsuUsecase()
        )
    }
    public static func createGetCountriesUsecase() -> GetCountriesUsecaseImpl {
        return GetCountriesUsecaseImpl(countryRepository: createCountryRepository())
    }

    public static func createAuthenticateUsecase() -> AuthenticateUsecaseImpl {
        return AuthenticateUsecaseImpl(baseRequest: createBaseRequest())
    }
    
    public static func createParAndFsuUsecase() -> PARAndFSUUsecaseImpl {
        return PARAndFSUUsecaseImpl(baseRequest: createBaseRequest())
    }
}
