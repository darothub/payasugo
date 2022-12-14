//
//  File.swift
//  
//
//  Created by Abdulrasaq on 14/12/2022.
//

import Foundation
import SwiftUI
public class Checkout: ObservableObject {
    @Published public var showCheckOutView: Bool = false
    @Published public var service: MerchantService = sampleServices[0]
    @Published public var amount: Int = 0
    @Published public var isSomeoneElsePaying: Bool = false
    
    public init() {
        //
    }
}
