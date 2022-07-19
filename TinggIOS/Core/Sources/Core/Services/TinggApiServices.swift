//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Foundation


public protocol TinggApiServices {
    func getCountries() -> DataRequest
    func request(tinggRequest: TinggRequest) -> DataRequest
}
