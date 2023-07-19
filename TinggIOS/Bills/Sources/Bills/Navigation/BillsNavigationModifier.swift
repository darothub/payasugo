//
//  BillsNavigationModifier.swift
//  
//
//  Created by Abdulrasaq on 18/07/2023.
//
import Checkout
import Core
import CoreUI
import Foundation
import SwiftUI
public struct BillsNavigationModifier: ViewModifier {
    var quickTopUpListener: ServicesListener
    public init(quickTopUpListener: ServicesListener) {
        self.quickTopUpListener = quickTopUpListener
    }
 
    
  
    @State var colorTint:Color = .blue
    public func body(content: Content) -> some View {
        content
            .changeTint($colorTint)
            .navigationDestination(for: BillsScreen.self, destination: { screen in
                switch screen {
                case .billers(let billers):
                    BillersView(billers: billers as! TitleAndListItem)
                        .onAppear {
                            colorTint = .blue
                        }
                case .fetchbillView(let billDetails):
                    FetchBillView(billDetails: .constant(billDetails as! BillDetails))
                     
                case let .billDetailsView(invoice, service):
                    BillDetailsView(
                        fetchBill: invoice as! Invoice,
                        service: service as! MerchantService
                    )
                case .nominationDetails(let invoice):
                    NominationDetailView(invoice: invoice as! Invoice)
                        .onAppear {
                            colorTint = .white
                        }
                case .categoriesAndServices(let items):
                    CategoriesAndServicesView(categoryNameAndServices: items as! [TitleAndListItem], quickTopUpListener: quickTopUpListener)
                    
                case .transactionListView(let model):
                    TransactionListView(listOfModel: model as! [TransactionSectionModel])
                }
            })
    }
}

extension View {
    public func billsNavigation(quickTopUpListener: ServicesListener) -> some View {
        modifier(BillsNavigationModifier(quickTopUpListener: quickTopUpListener))
    }
}
