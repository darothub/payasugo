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
            dbObserver: Observer<Country>()
        )
    }
    @MainActor
    public static func createOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(onboardingUseCase: createOnboardingUseCase())
    }
    public static func createOnboardingUseCase() -> OnboardingUseCase {
        return OnboardingUseCase(
            getCountriesAndDialCodeUsecase: createGetCountriesAndDialCodeUsecase(),
            getCountryByDialCodeUsecase: createGetCountryByDialCodeUsecase(),
            authenticateRepository: createAuthenticateUsecase(),
            parAndFsuRepository: createParAndFsuRepository()
        )
    }
    public static func createGetCountriesAndDialCodeUsecase() -> GetCountriesAndDialCodeUseCase {
        return GetCountriesAndDialCodeUseCase(countryRepository: createCountryRepository())
    }
    public static func createGetCountryByDialCodeUsecase() -> GetCountryByDialCodeUsecase {
        return GetCountryByDialCodeUsecase(countryRepository: createCountryRepository())
    }

    public static func createAuthenticateUsecase() -> AuthenticateRepositoryImpl {
        return AuthenticateRepositoryImpl(baseRequest: createBaseRequest())
    }
    
    public static func createParAndFsuRepository() -> PARAndFSURepositoryImpl {
        return PARAndFSURepositoryImpl(baseRequest: createBaseRequest())
    }
}
