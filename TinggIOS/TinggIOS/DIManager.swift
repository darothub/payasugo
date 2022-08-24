//
//  DependenciesManager.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 04/08/2022.
//

import Foundation
import Core
import SwiftUI
import Onboarding

struct DIManager {
    static func createApiServices() -> TinggApiServices {
        return BaseRepository()
    }
    static func createRealmManager() -> RealmManager {
        return RealmManager()
    }
    static func createBaseRequest() -> BaseRequest {
        return .init()
    }
    static func createCountryRepository() -> CountryRepositoryImpl {
        return CountryRepositoryImpl(
            baseRequest: createBaseRequest(),
            realmManager: createRealmManager()
        )
    }
    static func createOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(onboardingUseCase: createOnboardingUseCase())
    }
    static func createOnboardingUseCase() -> OnboardingUseCase {
        return OnboardingUsecaseImpl(
            getCountriesUsecase: createGetCountriesUsecase(),
            authenticateUsecase: createAuthenticateUsecase(),
            parUsecase: createParAndFsuUsecase()
        )
    }
    static func createGetCountriesUsecase() -> GetCountriesUsecaseImpl {
        return GetCountriesUsecaseImpl(countryRepository: createCountryRepository())
    }

    static func createAuthenticateUsecase() -> AuthenticateUsecaseImpl {
        return AuthenticateUsecaseImpl(baseRequest: createBaseRequest())
    }
    
    static func createParAndFsuUsecase() -> PARAndFSUUsecaseImpl {
        return PARAndFSUUsecaseImpl(baseRequest: createBaseRequest())
    }
}
