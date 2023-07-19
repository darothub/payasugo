//
//  BundleSelectionView.swift
//  
//
//  Created by Abdulrasaq on 30/11/2022.
//
import Core
import CoreUI
import Checkout
import SwiftUI
import Theme

public struct BundleSelectionView: View {
    @Binding var model: BundleModel
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State private var enrollments: [Enrollment] = []
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
                    DropDownView(selectedText: $model.selectedDataPlanName, dropDownList: $plans,  showDropDown: $dropDownShows, placeHoder: "Plans", lockTyping: true)
                    DropDownView(selectedText: $model.selectedBundleName, dropDownList: $bundleList, showDropDown: $bundleDropDownShows, placeHoder: "Select Bundles", lockTyping: true)
                        .showIfNot($dropDownShows)
                    DropDownView(selectedText: $model.selectedAccount, dropDownList: $accountList, showDropDown: $accountDropDownShows, placeHoder: "Select account", lockTyping: false, maxHeight: 100, keyboardType: .phonePad)
                        .showIfNot($dropDownShows)
                        .showIfNot($bundleDropDownShows)
                       
                    TinggButton(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Continue",
                        padding: 0
                    ) {
                      
                        //TODO
                        withAnimation {
                            let bundleService = Observer<BundleObject>().getEntities().first { $0.bundleName == model.selectedBundleName
                            }
                            if let bundleSelected = bundleService {
                                checkoutVm.showBundles = false
                                model.selectedBundleObject = bundleSelected
                                checkoutVm.selectedAmount = "\(bundleSelected.cost)"
                                checkoutVm.currentService = model.service
                                checkoutVm.currentAccountNumber = model.selectedAccount
                                checkoutVm.enrollments = enrollments
                                checkoutVm.showView = true
                            }
                         
                        }
                        
                    }
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
        .onChange(of: model.selectedDataPlanName) { newValue in
            bundleList = bundleServices.filter({ data in
                data.categoryName == newValue
            }).flatMap({ data in
                data.bundles.map {$0.bundleName}
            })
            let serviceEnrollments = Observer<Enrollment>().getEntities().filter{$0.hubServiceID == bundleServices[0].serviceID}
            enrollments = serviceEnrollments
            accountList = enrollments.map {$0.accountNumber}
        }
    }
}

struct BundleSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        BundleSelectionView(model: .constant(BundleModel()))
            .environmentObject(CheckoutDI.createCheckoutViewModel())
    }
}
