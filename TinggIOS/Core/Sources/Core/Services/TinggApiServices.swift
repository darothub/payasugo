//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Alamofire
import Foundation
import SwiftUI
public protocol TinggApiServices {
    func request(tinggRequest: TinggRequest) -> DataRequest
}

extension TinggApiServices {
    public func request(tinggRequest: TinggRequest) -> DataRequest {
        return AF.request(Utils.baseUrlStaging, method: .post,
                          parameters: tinggRequest, encoder: JSONParameterEncoder.default)
    }
    public func getCountries() -> DataRequest {
        return AF.request(Utils.baseUrlStaging+"countries.php/", method: .get)
    }
}

public struct TinggApiServicesKey: EnvironmentKey {
    public static let defaultValue: TinggApiServices = BaseRepository()
}

public extension EnvironmentValues {
    var tinggApiServices: TinggApiServices {
        get { self[TinggApiServicesKey.self] }
        set { self[TinggApiServicesKey.self] = newValue }
    }
}

extension View {
    public func tinggApiServices(_ tinggApiServices: TinggApiServices) -> some View {
        environment(\.tinggApiServices, tinggApiServices)
    }
}
