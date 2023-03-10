//
//  File.swift
//  
//
//  Created by Abdulrasaq on 02/03/2023.
//

import Foundation
@MainActor
public protocol CheckoutProtocol {
    var fem: FavouriteEnrollmentModel { get set }
    var slm: ServicesListModel { get set }
    var sam: SuggestedAmountModel { get set }
}

