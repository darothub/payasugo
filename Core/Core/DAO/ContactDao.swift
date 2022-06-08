//
//  ContactDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol ContactDao {
    
    func getActiveCountryContactInfo(activeCountryId: String?) -> ObservedResults<Contact>

}
