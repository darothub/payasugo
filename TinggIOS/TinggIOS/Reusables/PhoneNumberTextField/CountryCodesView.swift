//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//
// swiftlint:disable all
import SwiftUI
import Combine
import Domain

public struct CountryCodesView: View {
    @Binding public var phoneNumber: String
    @Binding public var countryCode: String
    @State public var countryFlag = ""
    public var numberLength = 10
    @State var countries = [String: String]()
    @ObservedObject var codeTextField = ObservableTextField()
    @EnvironmentObject var fetchCountries: FetchCountries
    @State public var showPhoneSheet = false

    public var body: some View {
        ZStack(alignment:.top) {
            HStack (spacing: 0) {
                Text(countryCode.isEmpty ? "🇧🇼 +267" : "\(countryFlag) +\(countryCode)")
                    .frame(width: 80, height: 50)
                    .background(Color.clear)
                    .cornerRadius(10)
                    .foregroundColor(countryCode.isEmpty ? .secondary : .black)
                    .onTapGesture {
                        withAnimation (.spring()) {
                            showPhoneSheet.toggle()
                        }
                }
                TextField("Phone Number", text: $phoneNumber)
                    .padding()
                    .keyboardType(.phonePad)
                    .onChange(of: phoneNumber) { newValue in
                        if newValue.count > 10 {
                            self.phoneNumber = String(newValue.prefix(numberLength))
                        }
                    }
            }
        }.sheet(isPresented: $showPhoneSheet) {
            CountryCodes(countryCode: $countryCode, countryFlag: $countryFlag, countries: countries)
        }
        .onAppear {
            getCountryCode()
        }
    }
    
    func getCountryCode () {
        countries = self.fetchCountries.$countriesDb.wrappedValue.reduce(into: [:]) { partialResult, country in
            partialResult[country.countryCode!] = country.countryDialCode
        }
        let sortedCountries = countries.sorted(by: <)
        if let flag = sortedCountries.first?.key {
            countryFlag = getFlag(country: flag)
        }
        if let code = sortedCountries.first?.value{
            countryCode = code
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    struct CountryViewHolder: View {
        @State var number = ""
        @State var code = ""

        var body: some View {
            CountryCodesView(phoneNumber: $number, countryCode: $code)        }
    }
    static var previews: some View {
        CountryViewHolder()
    }
}
