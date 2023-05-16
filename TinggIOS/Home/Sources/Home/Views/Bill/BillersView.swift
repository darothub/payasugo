//
//  CoreUI.swift
//  
//
//  Created by Abdulrasaq on 03/11/2022.
//
import Combine
import CoreUI
import CoreNavigation
import Core
import SwiftUI
import RealmSwift

public struct BillersView: View {
    @StateObject var hvm = HomeDI.createHomeViewModel()
    @EnvironmentObject var navigation: NavigationUtils
    @State private var enrolments = [Enrollment]()
    @State private var imageUrl = ""
    @State private var serviceCategoryId = ""
    @State private var showBundles = false
    @State private var selectedBundle = ""
    @State private var selectedAccount = ""
    @State private var mobileNumber = ""
    @State private var bundleService: [BundleData] = .init()
    @State private var enrollmentToRemove: Enrollment = .init()
    @State private var selectedMerchantService = sampleServices[0]
    @State var billers: TitleAndListItem = .init(title: "Sample", services: sampleServices)
    public init(billers: TitleAndListItem) {
        _billers = State(initialValue: billers)
    }
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                nominations()
                    .showIf(.constant(!enrolments.isEmpty))
                billersList()
                    .showIf(.constant(enrolments.isEmpty))
            }
            Image(systemName: "plus")
                .padding(20)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .background(.green)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                .padding(30)
                .scaleEffect(1)
                .onTapGesture {
                    withAnimation {
                        navigation.navigationStack.append( Screens.categoriesAndServices([billers])
                        )
                    }
                }
        }
        .customDialog(
            isPresented: $showBundles,
            backgroundColor: .constant(.clear),
            cancelOnTouchOutside: .constant(true)
        ) {
            BundleSelectionView(selectedBundle: selectedBundle, selectedAccount: selectedAccount, mobileNumber: mobileNumber, service: selectedMerchantService, enrollments: enrolments, bundleInfo: bundleService)
            
        }
        .onAppear {
            let services = billers.services
            if !services.isEmpty {
                serviceCategoryId = services[0].categoryID
                enrolments = hvm.nominationInfo.getEntities().filter{  $0.serviceCategoryID == serviceCategoryId
                }
            }
        }
        .handleViewStatesMods(uiState: hvm.$serviceBillUIModel) { content in
            log(message: content)
//            if !nom.isInvalidated {
//                hvm.nominationInfo.$objects.remove( nom)
//            }
        }
    }
    fileprivate func filterNominationByServiceCategoryId(id: String) -> [Enrollment] {
        hvm.nominationInfo.getEntities().filter{  $0.serviceCategoryID == id }
    }
    @ViewBuilder
    fileprivate func billersList() -> some View {
        List {
            ForEach(billers.services, id: \.id) { service in
                NavigationLink(value: service) {
                    HStack {
                        IconImageCardView(imageUrl: service.serviceLogo)
                            .scaleEffect(0.8)
                        Text(service.serviceName)
                    }.onTapGesture {
                        if service.isBundleService == "1" {
                            showBundles.toggle()
                            selectedMerchantService = service
                            bundleService = Observer<BundleData>().getEntities().filter({ data in
                                String(data.serviceID) == service.hubServiceID
                            })
                        } else {
                            if let bills = hvm.handleServiceAndNominationFilter(service: service, nomination: hvm.nominationInfo.getEntities()) {
                                withAnimation {
                                    navigation.navigationStack.append(
                                        Screens.billFormView(bills)
                                    )
                                }
                            }
                        }
                    }
                }
            }.listRowInsets(EdgeInsets())
        }.listStyle(.plain)
    }
    
    @ViewBuilder
    fileprivate func nominations() -> some View {
        List {
            ForEach(enrolments, id: \.clientProfileAccountID) { enrolment in
                NavigationLink(value: enrolment) {
                    SingleNominationView(nomination: enrolment.freeze()) { nomination, invoice in
                        navigation.navigationStack.append(
                            Screens.nominationDetails(invoice, nomination)
                        )
                    }
                }
            }.onDelete(perform: removeBill(at:))
        }
        
    }
    
    func removeBill(at offSet: IndexSet) {
        let nom: Enrollment = enrolments[offSet.first ?? 0]
        let service = billers.services.first { service in
            service.categoryID == nom.serviceCategoryID
        }
        if let s = service {
            let profileInfo = computeProfileInfo(service: s, accountNumber: nom.accountNumber )
            hvm.handleMCPRequests(action: .DELETE, profileInfoComputed: profileInfo, nom: nom)
            if let off = offSet.first {
                enrolments.remove(at: off)
            }
        }
    }
}

struct SingleNominationView: View {
    var nomination: Enrollment
    @State var onClick: (Enrollment, Invoice) -> Void = {_,_ in
        //TODO
    }
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .top) {
                IconImageCardView(imageUrl: nomination.serviceLogo ?? "")
                    .scaleEffect(0.9)
                VStack(alignment: .leading, spacing: 7) {
                    Text(nomination.accountName ?? "None")
                        .font(.caption)
                        .bold()
                    Text(nomination.accountAlias.uppercased())
                        .foregroundColor(.gray)
                        .font(.caption)
                }
            }
            Spacer()
            VStack(alignment: .leading, spacing: 7) {
                HStack {
                    Text("Updated")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(Date(), style:.relative )
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text("A/C No. \(nomination.accountNumber )")
                    .font(.caption)
                    .bold()
            }
        }
        .handleViewStatesMods(uiState: hvm.$uiModel) { content in
            log(message: content)
            if let invoice = content.data as? Invoice {
                onClick(nomination, invoice)
            }
        }
        .padding()
        .onTapGesture {
            hvm.getSingleDueBill(accountNumber: nomination.accountNumber, serviceId: String(nomination.hubServiceID))
//            hvm.observeUIModel(model: hvm.$uiModel, subscriptions: &hvm.subscriptions) { content in
//                let invoice = content.data as! Invoice
//                onClick(nomination, invoice)
//            }
        }
    }
}

struct BillersView_Previews: PreviewProvider {
    struct BillersViewHolder: View {
        @State var billers: TitleAndListItem = .init(title: "Sample", services: sampleServices)
        var body: some View {
            BillersView(billers: billers)
        }
    }
    static var previews: some View {
        NavigationStack {
            BillersViewHolder()
        }
    }
}

