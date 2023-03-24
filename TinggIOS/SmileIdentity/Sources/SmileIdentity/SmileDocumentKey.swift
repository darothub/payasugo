//
//  SmileDocumentKey.swift
//  
//
//  Created by Abdulrasaq on 23/03/2023.
//

import Foundation


enum SmileDocumentKey {
    enum Kenya: String, CaseIterable {
        case ALIEN_CARD, DRIVERS_LICENSE, NATIONAL_ID, PASSPORT, REFUGEE_ID
        
        var description: String {
            get {
                return self.rawValue.replacingOccurrences(of: "_", with: " ")
            }
            set(newValue) {
                let v = newValue.replacingOccurrences(of: " ", with: "_")
                self = Self(rawValue: v) ?? .PASSPORT
            }
        }
    }
    enum Ghana: String, CaseIterable {
        case GHANA_CARD, DRIVERS_LICENSE, NATIONAL_ID, PASSPORT, RESIDENT_CARD, SSNIT, VOTER_ID
        
        var description: String {
            get {
                return self.rawValue.replacingOccurrences(of: "_", with: " ")
            }
            set(newValue) {
                let v = newValue.replacingOccurrences(of: " ", with: "_")
                self = Self(rawValue: v) ?? .PASSPORT
            }
        }
    }
    
    enum Zambia: String, CaseIterable {
        case DRIVERS_LICENSE, NATIONAL_ID, PASSPORT, VOTER_ID
        
        var description: String {
            get {
                return self.rawValue.replacingOccurrences(of: "_", with: " ")
            }
            set(newValue) {
                let v = newValue.replacingOccurrences(of: " ", with: "_")
                self = Self(rawValue: v) ?? .PASSPORT
            }
        }
    }
}
