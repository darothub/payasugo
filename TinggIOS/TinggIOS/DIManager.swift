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
        return BaseRequest(apiServices: BaseRepository())
    }
    static func createCountryRepository() -> CountryRepositoryImpl {
        return CountryRepositoryImpl(
            apiService: createApiServices(),
            realmManager: createRealmManager()
        )
    }
    static func createOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(countryRepository: createCountryRepository(), baseRequest: createBaseRequest())
    }

}
