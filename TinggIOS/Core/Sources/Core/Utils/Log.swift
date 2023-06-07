//
// Log.swift
//  
//
//  Created by Abdulrasaq on 11/02/2023.
//

import Foundation

public class Log {
    public static func d(fileName: String = #file, message: String) {
        let nameOfFile = fileName.self.split(separator: ".")[0]
        print("\(nameOfFile) -> \n\(message)")
    }
}


