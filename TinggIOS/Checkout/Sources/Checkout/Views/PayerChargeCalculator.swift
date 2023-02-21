//
//  PayerChargeCalculator.swift
//  
//
//  Created by Abdulrasaq on 19/02/2023.
//
import Core
import Foundation

public class PayerChargeCalculator {
    
    public static func checkCharges(
        merchantPayer: MerchantPayer,
        merchantService: MerchantService,
        amount: Double,
        cardType: String? = nil,
        onChargesAccepted: (() -> Void) = {}
    ) {
        if merchantService.hasPayerCharge && merchantService.hasTierCharge {
            //Calculate tier charge
            
        }
    }
}
