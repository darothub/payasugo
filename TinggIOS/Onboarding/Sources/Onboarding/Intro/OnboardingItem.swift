//
//  OnboardingItem.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import Foundation
/// A blue print object for onboarding item.
/// Every onboarding view displays the onboarding item property.
struct OnboardingItem {
    /// The center image is the gif image animating at the center of the page.
    let centerImage: String
    /// Display information that corroborate the image.
    let info: String
    /// Provides more information about TinggiOS features.
    let subInfo: String
}

func exampleOnboarding() -> OnboardingItem {
    return OnboardingItem(centerImage: "slideimagetwo",
        info: "Never miss to pay a bill.\nGet instant bill due reminder!",
        subInfo: "Add your bills on Tingg and will send you\na reminder when your bill is due"
    )
}

func onboardingItems() -> [OnboardingItem] {
    [
        OnboardingItem(centerImage: "slideimageone",
           info: "Never miss to pay a bill.\nGet instant bill due reminder!",
           subInfo: "Add your bills on Tingg and will send you\na reminder when your bill is due"
       ),
        OnboardingItem(centerImage: "slideimagetwo",
           info: "Pay for any bill\non Tingg",
           subInfo: "From airtime to PayTv, Power, Water and\nrestaurant, pay for any bill on Tingg"
       )
    ]
}
