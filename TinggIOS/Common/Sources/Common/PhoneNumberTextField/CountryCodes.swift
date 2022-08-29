//
//  File.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//
// swiftlint:disable all
import Foundation
import SwiftUI
public struct CountryCodes : View {
    @Binding public var countryCode: String
    @Binding public var countryFlag: String
    public var countries = [String: String]()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    
    public var body: some View {
        GeometryReader { geo in
            List(countries.sorted(by: <), id: \.key) { key , value in
                viewBody(key, value)
            }
            .padding(.bottom)
            .frame(width: geo.size.width, height:  geo.size.height)
        }
    }
    @ViewBuilder
    fileprivate func viewBody(_ key: String, _ value: String) -> some View {
        HStack {
            Text("\(getFlag(country: key))")
                .accessibility(identifier: "countryflag")
            Text("\(getCountryName(countryCode: key) ?? key)")
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .accessibility(identifier: "countrydialcode")
            Spacer()
            Text("+\(value)").foregroundColor(colorScheme == .dark ? .white : .black)
        }.background(colorScheme == .dark ? .black.opacity(0) : .white)
            .font(.system(size: 20))
            .onTapGesture {
                self.countryCode = value
                self.countryFlag = key
                dismiss()
        }
    }
}

public func getCountryName(countryCode: String) -> String? {
    let current = Locale(identifier: "en_US")
    return current.localizedString(forRegionCode: countryCode)
}

public func getFlag(country: String) -> String {
  let base = 127397
  var tempScalarView = String.UnicodeScalarView()
  for i in country.utf16 {
    if let scalar = UnicodeScalar(base + Int(i)) {
      tempScalarView.append(scalar)
    }
  }
  return String(tempScalarView)
}
