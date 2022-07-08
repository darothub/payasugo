//
//  File.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//
// swiftlint:disable all
import Foundation
import SwiftUI
import Domain
public struct CountryCodes : View {
    @Binding public var countryCode: String
    @Binding public var countryFlag: String
    @EnvironmentObject var fetchCountries: FetchCountries
    var countries = [String: String]()
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        GeometryReader { geo in
            List(countries.sorted(by: <), id: \.key) { key , value in
                HStack {
                    Text("\(getFlag(country: key))")
                    Text("\(getCountryName(countryCode: key) ?? key)")
                    Spacer()
                    Text("+\(value)").foregroundColor(.secondary)
                }.background(Color.white)
                    .font(.system(size: 20))
                    .onTapGesture {
                        self.countryCode = value
                        self.countryFlag = getFlag(country: key)
                        withAnimation(.spring()) {
                            dismiss()
                        }
                }
            }
            .padding(.bottom)
            .frame(width: geo.size.width, height:  geo.size.height)
      
        }
    }
}

func getCountryName(countryCode: String) -> String? {
    let current = Locale(identifier: "en_US")
    return current.localizedString(forRegionCode: countryCode)
}

func getFlag(country:String) -> String {
    let base : UInt32 = 127397
    var flag = ""
    for v in country.unicodeScalars {
        flag.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return flag
}
