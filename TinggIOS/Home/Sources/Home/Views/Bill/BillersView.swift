//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 03/11/2022.
//
import Core
import SwiftUI
@MainActor
public struct BillersView: View {
    @State var billers: TitleAndListItem = .init(title: "Sample", services: sampleServices)
    @State var enrolments = [Enrollment]()
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
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
                    let selectedBiller = hvm.categoryNameAndServices.filter { dict in
                        dict.key == billers.title
                    }
                    let categoryNameAndServices = selectedBiller.keys
                        .sorted(by: <)
                        .map{TitleAndListItem(title: $0, services: selectedBiller[$0]!)}
                    withAnimation {
                        navigation.navigationStack = [
                            .home,
                            .billers(billers, enrolments),
                            .categoriesAndServices(categoryNameAndServices)
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
                    SingleNominationView(nomination: enrolment)
                }
            }
        }.listStyle(.plain)
    }
}

struct SingleNominationView: View {
    var nomination: Enrollment
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
                Text("Updated")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("A/C No. \(nomination.accountNumber ?? "N/A")")
                    .font(.caption)
                    .bold()
            }
        }.padding()
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
        BillersViewHolder()
        
    }
}
