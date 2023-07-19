//
//  FlagTextField.swift
//  
//
//  Created by Abdulrasaq on 13/07/2023.
//

import SwiftUI

public struct FlagTextField: View {
    @Binding var phoneNumber: String
    @Binding var flags: [String]
    @Binding private var selectedFlag: String
    private var validation: (String) -> Bool
   
    @State private var isDropDownVisible = false
  
    public init(phoneNumber: Binding<String>, flags: Binding<[String]>, selectedFlag: Binding<String>, validation: @escaping (String) -> Bool) {
        self._phoneNumber = phoneNumber
        self._flags = flags
        self._selectedFlag = selectedFlag
        self.validation = validation
    }
    public var body: some View {
        HStack {
            Menu {
                ForEach(flags, id: \.self) { flag in
                    Button(action: {
                        selectedFlag = flag
                        isDropDownVisible = false
                    }) {
                        Text(flag)
                            .accessibility(identifier: "countryflag")
                    }
                }
            } label: {
                Text(selectedFlag)
                    .font(.headline)
                    .accessibility(identifier: "countrycodeandflag")
                
            }
            .foregroundColor(.black)
            TextField("Phone Number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .accessibility(identifier: "countrytextfield")
               
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .validateBorderStyle(text: $phoneNumber, validation: validation)
    }
}


struct FlagTextField_Previews: PreviewProvider {
    static var previews: some View {
        NewTest()
    }
}


public func getDeviceCountryCode() -> String {
    let countryLocale = NSLocale.current
    guard let countryCode = countryLocale.language.region?.identifier else {
        return "NG"
    }
    return countryCode
}
