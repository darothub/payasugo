//
// Log.swift
//  
//
//  Created by Abdulrasaq on 11/02/2023.
//

import Foundation

public class Log {
    public static func d(fileStr: String = #file, funcStr: String = #function, message: String) {
        var fileName = fileStr.components(separatedBy: "/").last ?? ""
        fileName = fileName.components(separatedBy:".").first ?? ""
        let printFunc = "\(fileName): \(funcStr) -> \(message)"
        print(printFunc)
    }
}


