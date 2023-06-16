//
//  BundleSelectionView.swift
//  
//
//  Created by Abdulrasaq on 30/11/2022.
//
import Core
import CoreUI

import SwiftUI
import Theme

public struct BundleSelectionView: View {
    @Binding var model: BundleModel
    @State private var enrollments: [Enrollment] = .init()
    @State private var bundleList: [String] = []
    @State private var accountList: [String] = []
    @State private var plans:[String] = []
    @State private var bundleServices: [BundleData] = .init()
    @State private var dropDownShows = false
    @State private var bundleDropDownShows = false
    @State private var accountDropDownShows = false
    public init(model: Binding<BundleModel>) {
        self._model = model
    }
    public var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Group {
                    Text(model.service.serviceName)
                    DropDownView(selectedText: $model.selectedDataPlan, dropDownList: $plans,  showDropDown: $dropDownShows, placeHoder: "Plans", lockTyping: true)
                    DropDownView(selectedText: $model.selectedBundle, dropDownList: $bundleList, showDropDown: $bundleDropDownShows, placeHoder: "Select Bundles", lockTyping: true)
                        .showIfNot($dropDownShows)
                    DropDownView(selectedText: $model.selectedAccount, dropDownList: $accountList, showDropDown: $accountDropDownShows, placeHoder: "Select account", lockTyping: true)
                        .showIfNot($dropDownShows)
                        .showIfNot($bundleDropDownShows)
                       
                    TextField("placeHolder", text: $model.mobileNumber)
                        .padding([.horizontal, .vertical], 15)
                        .font(.caption)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(lineWidth: 0.5)
                        )
                        .showIfNot($dropDownShows)
                        .showIfNot($bundleDropDownShows)
                        .showIfNot($accountDropDownShows)
                   
                    
                    TinggButton(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Continue",
                        padding: 0
                    ) {
                        //TODO
                    }
//                    .showIfNot($dropDownShows)
//                    .showIfNot($bundleDropDownShows)
//                    .showIfNot($accountDropDownShows)
                }.padding(.horizontal)
            }
            .padding(30)
            .background(
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(.white)
                    .padding()
            )
            .alignmentGuide(.top) { d in
                d[.top] - 30
            }
            .padding()
            IconImageCardView(imageUrl: model.service.serviceLogo)
                .clipShape(Circle())
                .scaleEffect(0.9)
    
        }.background(.clear)
        .onAppear {
            bundleServices = Observer<BundleData>().getEntities().filter({ data in
                String(data.serviceID) == model.service.hubServiceID
            })
            plans = bundleServices.map { data in
                data.categoryName
            }
        }
        .onChange(of: model.selectedDataPlan) { newValue in
            bundleList = bundleServices.filter({ data in
                data.categoryName == newValue
            }).flatMap({ data in
                data.bundles.map {$0.bundleName}
            })
            enrollments = Observer<Enrollment>().getEntities()
            accountList = enrollments.filter{$0.hubServiceID == bundleServices[0].serviceID}.map {$0.accountNumber
            }
        }
    }
}

public struct BundleModel {
    public var selectedBundle: String
    public var selectedAccount: String
    public var selectedDataPlan: String
    public var mobileNumber: String
    public var service: MerchantService
    public init(selectedBundle: String = "", selectedAccount: String = "", selectedDataPlan: String = "", mobileNumber: String = "", service: MerchantService = MerchantService()) {
        self.selectedBundle = selectedBundle
        self.selectedAccount = selectedAccount
        self.selectedDataPlan = selectedDataPlan
        self.mobileNumber = mobileNumber
        self.service = service
    }
    
}

struct BundleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BundleSelectionView(model: .constant(BundleModel()))
    }
}
