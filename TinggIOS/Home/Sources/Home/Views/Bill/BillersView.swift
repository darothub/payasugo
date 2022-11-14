//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 03/11/2022.
//
import Combine
import Core
import SwiftUI

@MainActor
public struct BillersView: View {
    @State var billers: TitleAndListItem = .init(title: "Sample", services: sampleServices)
    @State var enrolments = [Enrollment]()
    @State var imageUrl = ""
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
    var profileInfoComputed: String {
        ""
//        "\(service.receiverSourceAddress)|\(fetchBill.billReference)|\(service.serviceName)|\(service.hubClientID)|\(service.hubServiceID)|\(service.categoryID)||||||||"
        
    }
    public init(billers: TitleAndListItem, enrolments : [Enrollment]) {
        _billers = State(initialValue: billers)
        _enrolments = State(initialValue: enrolments)
        
    }
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                nominations()
                    .showIf(.constant(!enrolments.isEmpty))
                viewBody()
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
                        navigation.navigationStack = [
                            .home,
                            .billers(billers, enrolments),
                            .categoriesAndServices([billers])
                        ]
                    }
                }
        }
    }
    
    @ViewBuilder
    fileprivate func viewBody() -> some View {
        List {
            ForEach(billers.services, id: \.id) { service in
                NavigationLink(value: service) {
                    HStack {
                        RemoteImageCard(imageUrl: service.serviceLogo)
                            .scaleEffect(0.8)
                        Text(service.serviceName)
                    }
                }
            }
        }.listStyle(.plain)
    }
    
    @ViewBuilder
    fileprivate func nominations() -> some View {
        List {
            ForEach(enrolments, id: \.clientProfileAccountID) { enrolment in
                NavigationLink(value: enrolment) {
                    SingleNominationView(nomination: enrolment) { nomination, invoice in
                        navigation.navigationStack = [
                            .home,
                            .billers(billers, enrolments),
                            .nominationDetails(invoice, nomination)
                        ]
                    }
                }
            }.onDelete { index in
                let nom: Enrollment = enrolments[index.count]
                let service = billers.services.first { service in
                    service.categoryID == nom.serviceCategoryID
                }
                if let s = service, let accountNumber = nom.accountNumber {
                    let profileInfo = computeProfileInfo(service: s, accountNumber: accountNumber)
    //                homeViewModel.saveBill(tinggRequest: request)
                    hvm.handleMCPRequest(action: .DELETE, profileInfoComputed: profileInfo)
                }
                hvm.nominationInfo.$objects.remove(nom)
            }
        }
        
    }
}

struct NomintaionListView: View {
    @State var enrolments = sampleNominations
    var body: some View {
        List {
            ForEach(enrolments, id: \.clientProfileAccountID) { enrolment in
                NavigationLink(value: enrolment) {
                    SingleNominationView(nomination: enrolment)
                }
            }
        }
        .listStyle(.plain)
    }
}

struct SingleNominationView: View {
    @State var nomination: Enrollment
    @State var onClick: (Enrollment, Invoice) -> Void = {_,_ in}
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    var body: some View {
        HStack(alignment: .top) {
            HStack(alignment: .top) {
                RemoteImageCard(imageUrl: nomination.serviceLogo ?? "")
                    .scaleEffect(0.9)
                VStack(alignment: .leading, spacing: 7) {
                    Text(nomination.accountName ?? "None")
                        .font(.caption)
                        .bold()
                    Text(nomination.accountAlias?.uppercased() ?? "None")
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
                Text("A/C No. \(nomination.accountNumber ?? "N/A")")
                    .font(.caption)
                    .bold()
            }
        }
        .handleViewStates(uiModel: $hvm.uiModel, showAlert: .constant(true))
        .padding()
        .onTapGesture {
            if let accountNumber = nomination.accountNumber {
                hvm.getSingleDueBill(accountNumber: accountNumber, serviceId: String(nomination.hubServiceID))
                hvm.observeUIModel(model: hvm.$uiModel) { content in
                    let invoice = content.data as! Invoice
                    onClick(nomination, invoice)
                }
            }
        }
    }
}

struct BillersView_Previews: PreviewProvider {
    struct BillersViewHolder: View {
        @State var billers: TitleAndListItem = .init(title: "Sample", services: sampleServices)
        var nom: [Enrollment] {
            sampleNominations
        }
        var body: some View {
            BillersView(billers: billers, enrolments: nom)
        }
    }
    static var previews: some View {
        NavigationStack {
            BillersViewHolder()
                .environmentObject(HomeDI.createHomeViewModel())
        }
    }
}

