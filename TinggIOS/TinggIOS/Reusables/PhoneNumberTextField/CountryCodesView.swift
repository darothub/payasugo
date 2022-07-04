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
    @State public var phoneNumber = ""
    @State public var y: CGFloat = 250
    @State public var countryCode = ""
    @State public var countryFlag = ""
    public var numberLength = 10
    @ObservedObject var codeTextField = ObservableTextField()
    @StateObject var fetchCountries: FetchCountries = FetchCountries()
    @State public var showPhoneSheet = false
    public init(){}
    public var body: some View {
        ZStack(alignment:.top) {
            HStack (spacing: 0) {
                Text(countryCode.isEmpty ? "🇦🇺 +61" : "\(countryFlag) +\(countryCode)")
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
            }.onAppear {
                fetchCountries.$phoneFieldDetails
                    .sink { result in
//                        countryCode = result
                        print("Countries map \(result)")
                    }
                    .store(in: &fetchCountries.subscription)
            }
        }.sheet(isPresented: $showPhoneSheet) {
            CountryCodes(countryCode: $countryCode, countryFlag: $countryFlag)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodesView()
    }
}
