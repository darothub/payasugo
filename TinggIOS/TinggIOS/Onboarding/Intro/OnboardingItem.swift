//
//  OnboardingItem.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import Foundation
struct OnboardingItem {
    let centerImage: String
    let info: String
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
