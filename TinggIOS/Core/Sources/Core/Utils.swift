//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Foundation
import SwiftUI
public enum Utils {
    public static let baseUrlStaging = "https://kartana.tingg.africa/pci/mula_ke/api/v1/"
    public static let defaultNetworkServiceId = "DEFAULT_NETWORK_SERVICE_ID"
}
public enum Screens {
    case launch, intro, home
}

public class NavigationUtils: ObservableObject {
    @Published public var screen = Screens.launch
    @Published public var navigatePermission = true
    public init() {
        // Intentionally unimplemented...needed for modular accessibility
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

public func addDaysToCurrentDate(numOfDays: Int) -> Date {
    let currentDate = Date()
    var dateComponent = DateComponents()
    dateComponent.day = numOfDays
    let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
    return futureDate!
}

public func formatDateToString(date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd hh:mm:ss"
    let now = df.string(from: date)
    return now
}
