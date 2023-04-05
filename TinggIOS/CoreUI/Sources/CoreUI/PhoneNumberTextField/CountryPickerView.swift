//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//
// swiftlint:disable all
import Foundation
import SwiftUI
import Combine
public struct CountryPickerView: View {
    @Binding public var phoneNumber: String
    @Binding public var countryCode: String
    @Binding public var countryFlag: String
    public var numberLength = 10
    var countries: [String: String]
    @ObservedObject var codeTextField = ObservableTextField()
    @State public var showPhoneSheet = false
    @Environment(\.colorScheme) var colorScheme
    /// ``CountryPickerView`` initialiser
    /// - Parameters:
    ///   - phoneNumber: input phone number string
    ///   - countryCode: ``Country/code``
    ///   - countryFlag: Flag
    ///   - countries: A dictionary of countries and their code
    public init(phoneNumber: Binding<String>, countryCode: Binding<String>, countryFlag: Binding<String>, countries: [String: String]){
        self._phoneNumber = phoneNumber
        self._countryCode = countryCode
        self._countryFlag = countryFlag
        self.countries = countries
    }
    fileprivate func checkLength(_ newValue: String) {
        if newValue.count > 10 {
            self.phoneNumber = String(newValue.prefix(numberLength))
        }
    }
    
    public var body: some View {
        ZStack(alignment:.top) {
            HStack (spacing: 0) {
                Text(countryCode.isEmpty ? "error" : "\(getFlag(country: countryFlag)) +\(countryCode)")
                    .frame(width: 80, height: 50)
                    .background(Color.clear)
                    .cornerRadius(10)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .onTapGesture(perform: tap)
                    .accessibility(identifier: "countrycodeandflag")
                
                TextField("Phone Number", text: $phoneNumber)
                    .padding()
                    .keyboardType(.phonePad)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .onChange(of: phoneNumber, perform: change)
                    .accessibility(identifier: "countrytextfield")
            }
        }.sheet(isPresented: $showPhoneSheet) {
            CountryListView(
                countryCode: $countryCode,
                countryFlag: $countryFlag,
                countries: countries
            )
        }
        .onAppear {
            countryFlag = getCountryFlag()
            countryCode = getCountryCode()
        }
    }
    fileprivate func tap() -> Void {
        showPhoneSheet.toggle()
    }
    fileprivate func change(value: String) -> Void {
        checkLength(value)
    }
    fileprivate func getCountryFlag() -> String {
        countries.sorted(by: <).first?.key ?? ""
    }
    fileprivate func getCountryCode () -> String {
        if let code = countries.sorted(by: <).first?.value {
            return code
        }
        return ""
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    struct CountryViewHolder: View {
        @State var number = ""
        @State var code = ""
        @State var flag = "NG"
        @State var countries = [String:String]()

        var body: some View {
            CountryPickerView(phoneNumber: $number, countryCode: $code, countryFlag: $flag, countries: countries)
        }
    }
    static var previews: some View {
        CountryViewHolder()
    }
}