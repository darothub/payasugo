//
//  File.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//

import Foundation

class ObservableTextField: ObservableObject {
    @Published var value = "" {
        didSet {
            if value.count > 3 {
                value = String(value.prefix(3))
            }
        }
    }
}
