//
//  BiodataView.swift
//  
//
//  Created by Abdulrasaq on 27/03/2023.
//
import CoreUI
import SwiftUI

struct BiodataView: View {
    @State private var dataModel: KYCDataModel = .init()
    @State private var idTypes: [String] = ["National ID"]
    @State private var birthDate = Date.now
    @State private var showDropDown = false
    private var firstNameLabel = "First Name"
    private var lastNameLabel = "Last Name"
    private var idTypesLabel = "ID Types"
    private var nationalIdLabel = "National ID"
    private var nationalityLabel = "Nationality"
    private var kraPinLabel = "KRA PIN"
    private var sourceOfIncomeLabel = "Source of Income/Funds"
    private var homeAddressLabel = "Home address"
    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    Spacer()
                    Text("Lets get to know you")
                    Text("Please provide us with following information")
                        .font(.subheadline)
                }.frame(maxWidth: .infinity, maxHeight: geo.size.height/4)
                    .padding()
                    .foregroundColor(.white)
                    .background(
                        Rectangle()
                            .fill(Color(red: 0.0, green: 0.0, blue: 0.4))
                    )
                    .ignoresSafeArea(edges: .all)
                ScrollView(showsIndicators: false) {
                    VStack {
                        Group {
                            TextFieldView(fieldText: $dataModel.firstName, label: firstNameLabel, placeHolder: firstNameLabel)
                            TextFieldView(fieldText: $dataModel.lastName, label: lastNameLabel, placeHolder: lastNameLabel)
                            DropDownView(selectedText: $dataModel.nationalID, dropDownList: $idTypes, showDropDown: $showDropDown, label: idTypesLabel)
                            Group {
                                TextFieldView(fieldText: $dataModel.nationalID, label: nationalIdLabel, placeHolder: nationalIdLabel)
                                VStack(alignment: .leading) {
                                    Text("Date of Birth")
                                        .font(.subheadline)
                                    DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) {
                                                    Text("Select date of birth")
                                    }.padding(13)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(lineWidth: 0.5)
                                    ).foregroundColor(.black)
                                }
                                TextFieldView(fieldText: $dataModel.nationality, label: nationalityLabel, placeHolder: nationalityLabel)
                                TextFieldView(fieldText: $dataModel.sourceOfIncome, label: sourceOfIncomeLabel, placeHolder: sourceOfIncomeLabel)
                                TextFieldView(fieldText: $dataModel.address, label: homeAddressLabel, placeHolder: homeAddressLabel)
                                TinggButton(buttonLabel: "Next") {
                                    print("")
                                }
                            }.showIfNot($showDropDown)
                        }.padding(.top)
                    }.padding(.horizontal)
                }
            }
          
        }

    }
}

struct BiodataView_Previews: PreviewProvider {
    static var previews: some View {
        BiodataView()
    }
}

struct KYCDataModel {
    var firstName: String = ""
    var lastName: String = ""
    var idType: String = ""
    var nationalID: String = ""
    var dob: String = ""
    var nationality: String = ""
    var kraPIN: String = ""
    var sourceOfIncome : String = ""
    var address: String = ""
}
