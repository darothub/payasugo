//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 26/06/2022.
//
// swiftlint:disable all
import SwiftUI

public struct CountryCodesView: View {
    @State public public var phoneNumber = ""
    @State public var y: CGFloat = 150
    @State public var countryCode = ""
    @State public var countryFlag = ""
    @ObservedObject var codeTextField = ObservableTextField()
    public init(){}
    public var body: some View {
        ZStack {
            HStack (spacing: 0) {
                Text(countryCode.isEmpty ? "🇦🇺 +61" : "\(countryFlag) +\(countryCode)")
                    .frame(width: 80, height: 50)
                    .background(Color.clear)
                    .cornerRadius(10)
                    .foregroundColor(countryCode.isEmpty ? .secondary : .black)
                    .onTapGesture {
                        withAnimation (.spring()) {
                            self.y = 0
                        }
                }
                TextField("Phone Number", text: $phoneNumber)
                    .padding()
                    .frame(width: 200, height: 50)
                    .keyboardType(.phonePad)
            }.padding()
            
            CountryCodes(countryCode: $countryCode, countryFlag: $countryFlag, y: $y)
                .offset(y: y)
        
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodesView()
    }
}
