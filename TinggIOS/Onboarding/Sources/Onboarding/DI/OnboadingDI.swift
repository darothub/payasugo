//
//  OnboardingDI.swift
//  
//
//  Created by Abdulrasaq on 24/08/2022.
//

import Foundation
import Core

/// Dependency injection struct for onboarding package
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
    public static func createActivationCodeUsecase() -> ActivationCodeUsecase {
        return ActivationCodeUsecase(sendRequest: BaseRequest())
    }
    public static func createSystemUpdateUsecase() -> SystemUpdateUsecase {
        return SystemUpdateUsecase()
    }
    @MainActor public static func createGetCountriesAndDialCodeUseCase() -> GetCountriesAndDialCodeUseCase {
        return GetCountriesAndDialCodeUseCase(countryRepository: CountryRepositoryImpl(baseRequest: BaseRequest(), dbObserver: Observer<CountryInfo>()))
    }
    @MainActor public static func createOnboardingVM() -> OnboardingVM {
        OnboardingVM(
            activationUsecase: createActivationCodeUsecase(),
            systemUpdateUsecase: createSystemUpdateUsecase(),
            getCountriesDictionaryUsecase: createGetCountriesAndDialCodeUseCase()
        )
    }
}
