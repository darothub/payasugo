//
//  File.swift
//  
//
//  Created by Abdulrasaq on 17/10/2022.
//

import Foundation
public enum Screens: Hashable {
    case intro,
         home,
         buyAirtime,
         billers(TitleAndListItem),
         categoriesAndServices([TitleAndListItem]),
         billFormView(BillDetails),
         billDetailsView(Invoice, MerchantService),
         nominationDetails(Invoice, Enrollment),
         pinCreationView,
         securityQuestionView,
         cardDetailsView(CreateCardChannelResponse?, Invoice?),
         cardWebView(String)
}




