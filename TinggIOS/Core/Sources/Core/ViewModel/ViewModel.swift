//
//  File.swift
//  
//
//  Created by Abdulrasaq on 29/07/2022.
//

import Foundation
import SwiftUI
public protocol ViewNavigation {
    func navigate<D>(destination: DestinationView) -> D where D: View
}


public enum DestinationView {
    case home, intro, phoneverification, otpview
}
