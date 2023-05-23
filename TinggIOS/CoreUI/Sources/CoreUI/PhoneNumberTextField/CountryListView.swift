//
//  File.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//
// swiftlint:disable all
import Foundation
import SwiftUI
public struct CountryListView : View {
    @Binding public var countryCode: String
    @Binding public var countryFlag: String
    public var countries = [String: String]()
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    public var body: some View {
        VStack {
            List(countries.sorted(by: <), id: \.key) { key , value in
                viewBody(key, value)
                    .listRowBackground(Color.white)
            }
            .padding(.bottom)
            .background(Color.gray.opacity(0.1))
            .scrollContentBackground(.hidden)
        }.background(.white)
    }
    @ViewBuilder
    fileprivate func viewBody(_ key: String, _ value: String) -> some View {
        HStack {
            Text("\(getFlag(country: key))")
                .accessibility(identifier: "countryflag")
            Text("\(getCountryName(countryCode: key) ?? key)")
                .foregroundColor(colorScheme == .dark ? .black : .black)
                .accessibility(identifier: "countrydialcode")
            Spacer()
            Text("+\(value)").foregroundColor(colorScheme == .dark ? .black : .black)
        }
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
