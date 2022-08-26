//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//
// swiftlint:disable all
import SwiftUI
import Combine
public struct CountryCodesView: View {
    @Binding public var phoneNumber: String
    @Binding public var countryCode: String
    @State public var countryFlag = ""
    public var numberLength = 10
    @Binding var countries: [String: String]
    @ObservedObject var codeTextField = ObservableTextField()
    @State public var showPhoneSheet = false
    public init(phoneNumber: Binding<String>, countryCode: Binding<String>, countries: Binding<[String: String]>){
        self._phoneNumber = phoneNumber
        self._countryCode = countryCode
        self._countries = countries
    }
    fileprivate func checkLength(_ newValue: String) {
        if newValue.count > 10 {
            self.phoneNumber = String(newValue.prefix(numberLength))
        }
    }
    
    public var body: some View {
        ZStack(alignment:.top) {
            HStack (spacing: 0) {
                Text("\(countryFlag) +\(countryCode)")
                    .frame(width: 80, height: 50)
                    .background(Color.clear)
                    .cornerRadius(10)
                    .foregroundColor(.black)
                    .onTapGesture {
                        showPhoneSheet.toggle()
                    }
                    .accessibility(identifier: "countrycodeandflag")
                
                TextField("Phone Number", text: $phoneNumber)
                    .padding()
                    .keyboardType(.phonePad)
                    .foregroundColor(.black)
                    .onChange(of: phoneNumber) { newValue in
                        checkLength(newValue)
                    }
                    .accessibility(identifier: "countrytextfield")
            }
        }.sheet(isPresented: $showPhoneSheet) {
            CountryCodes(
                countryCode: $countryCode,
                countryFlag: $countryFlag,
                countries: countries
            )
        }
        .task {
            getCountryCode()
        }
    }
    
    func getCountryCode () {
        let sortedCountries = countries.sorted(by: <)
        if let flag = sortedCountries.first?.key {
            countryFlag = getFlag(country: flag)
        }
        if let code = sortedCountries.first?.value {
            countryCode = code
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    struct CountryViewHolder: View {
        @State var number = ""
        @State var code = ""
        @State var countries = [String:String]()

        var body: some View {
            CountryCodesView(phoneNumber: $number, countryCode: $code, countries: $countries)
        }
    }
    static var previews: some View {
        CountryViewHolder()
    }
}
public extension CountryCodesView {
    func countryFieldViewStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}
public struct CountryViewDropDownStyle: ViewModifier {
    @Binding var isValidPhoneNumber: Bool
    public init(isValidPhoneNumber: Binding<Bool>){
        self._isValidPhoneNumber = isValidPhoneNumber
    }
    public func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
            .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
                .someForegroundColor(condition: _isValidPhoneNumber)
            )
            .padding(.horizontal, 25)
    }
}
