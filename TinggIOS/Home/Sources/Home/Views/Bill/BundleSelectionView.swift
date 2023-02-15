//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 30/11/2022.
//
import Core
import Common

import SwiftUI
import Theme

struct BundleSelectionView: View {
    @State var selectedBundle = ""
    @State var selectedAccount = ""
    @State var selectedDataPlan = ""
    @State var mobileNumber = ""
    @State var service = MerchantService()
    @State var enrollments: [Enrollment] = .init()
    @State var bundleList: [String] = []
    @State var accountList: [String] = []
    @State var bundleInfo: [BundleData] = .init()
    @State var plans:[String] = []
    @State var dropDownShows = false
    @State var bundleDropDownShows = false
    @State var accountDropDownShows = false
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text(service.serviceName)
                DropDownView(selectedText: $selectedDataPlan, dropDownList: $plans,  showDropDown: $dropDownShows, placeHoder: "Plans", lockTyping: true)
                DropDownView(selectedText: $selectedBundle, dropDownList: $bundleList, showDropDown: $bundleDropDownShows, placeHoder: "Select Bundles", lockTyping: true)
                    .showIfNot($dropDownShows)
                DropDownView(selectedText: $selectedAccount, dropDownList: $accountList, showDropDown: $accountDropDownShows, placeHoder: "Select account", lockTyping: true)
                    .showIfNot($dropDownShows)
                    .showIfNot($bundleDropDownShows)
                   
                TextField("placeHolder", text: $mobileNumber)
                    .padding([.horizontal, .vertical], 15)
                    .font(.caption)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                    )
                    .showIfNot($dropDownShows)
                    .showIfNot($bundleDropDownShows)
                    .showIfNot($accountDropDownShows)
                Spacer()
                
                button(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: "Continue",
                    padding: 0
                ) {
                    
                 
                }
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 4.0)
                    .fill(.white)
                    .shadow(color: .black, radius: 3, x: 1, y: 1)
            )
            .alignmentGuide(.top) { d in
                d[.top] - 50
            }
            .padding()
            IconImageCardView(imageUrl: service.serviceLogo)
                .clipShape(Circle())
                .scaleEffect(0.9)
    
        }.background(.clear)
        .onAppear {
            plans = bundleInfo.map { data in
                data.categoryName
            }
        }
        .onChange(of: selectedDataPlan) { newValue in
            bundleList = bundleInfo.filter({ data in
                data.categoryName == newValue
            }).flatMap({ data in
                data.bundles.map {$0.bundleName}
            })
            accountList = enrollments.filter{$0.hubServiceID == bundleInfo[0].serviceID}.map {$0.accountNumber ?? ""}
        }
    }
}

struct BundleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BundleSelectionView()
    }
}
