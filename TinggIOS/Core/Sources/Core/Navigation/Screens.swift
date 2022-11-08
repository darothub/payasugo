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
         billers(TitleAndListItem, [Enrollment]),
         categoriesAndServices([TitleAndListItem]),
         billFormView(BillDetails)
    
   
}
public enum Home: Hashable {
    case categoriesAndServices, billFormView, home
}



