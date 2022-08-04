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

struct DepenedenciesManager {
    func createApiServices() -> TinggApiServices {
        return BaseRepository()
    }
    func createRealmManager() -> RealmManager {
        return RealmManager()
    }
    func createCountryRepository() -> CountryRepository {
        return CountryRepository(
            apiService: createApiServices(),
            realmManager: createRealmManager()
        )
    }
    func createFetchCountries() -> FetchCountries {
        return FetchCountries(
            countryRepository: createCountryRepository(),
            countryServices: createApiServices()
        )
    }
    func createOnboardingViewModel() -> OnboardingViewModel {
        return OnboardingViewModel(
            fetchCountries: createFetchCountries(),
            tinggApiServices: createApiServices()
        )
    }

}
