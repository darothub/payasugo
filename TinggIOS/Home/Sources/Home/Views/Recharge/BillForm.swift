//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 05/09/2022.
//

import SwiftUI
import Common
import Theme
import Core
struct BillFormView: View {
    @State var accountNumber: String = ""
    @Binding var service: MerchantService
    @Binding var billDetails: BillDetails
    @StateObject var homeViewModel = HomeDI.createHomeViewModel()
    @Environment(\.dismiss) var dismiss
    @State var showAccounts = false
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .top) {
                    TopBackground()
                        .alignmentGuide(.top) { d in d[.bottom] * 0.4 }
                        .frame(height: geo.size.height * 0.1)
                    RemoteImageCard(imageUrl: billDetails.logo)
                        .scaleEffect(1.2)
                }
                Text(billDetails.serviceName)
                    .padding(20)
                    .font(.system(size: PrimaryTheme.mediumTextSize).bold())
                    .foregroundColor(.black)
                
                TextFieldView(
                    fieldText: $accountNumber,
                    label: "Enter your \(billDetails.label)",
                    placeHolder: billDetails.label
                )
                .bottomSheet(present: $showAccounts, sheet: {
                    Picker(selection: $accountNumber) {
                        ForEach(billDetails.info, id: \.id) { info in
                            Text(info.accountNumber ?? "None")
                            .tag("\(info.accountNumber ?? "")")
                        }
                    } label: {
                        Text("Existing account number")
                    }.pickerStyle(WheelPickerStyle())
                })
                .onChange(of: accountNumber, perform: { newValue in
                    showAccounts = false
                    print("NewValue \(accountNumber)")
                })
                .onTapGesture (perform: onTextFieldTap)
            
                Spacer()
                
                NavigationLink(destination: BillDetailsView(fetchBill: homeViewModel.singleBill, service: service), isActive: $homeViewModel.navigateBillDetailsView) {
                    button(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Get bill"
                    ) {
                        homeViewModel.getSingleDueBill(
                            accountNumber: accountNumber,
                            serviceId: billDetails.serviceId
                        )
                    }.handleViewState(uiModel: $homeViewModel.uiModel)
                }
            }
        }
    }
    func onTextFieldTap() {
        showAccounts = true
    }
}

struct BillFormView_Previews: PreviewProvider {
    struct BillFormViewHolder: View {
        @State var service: MerchantService = .init()
        @State var bills = BillDetails(logo: "", label: "", serviceName: "", serviceId: "", info: [Enrollment]())
        var body: some View {
            BillFormView(service: $service, billDetails: $bills)
        }
    }
    static var previews: some View {
        BillFormViewHolder()
    }
}


struct TopBackground: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
    }
}

struct BillDetails {
    let logo:String
    let label: String
    let serviceName: String
    let serviceId: String
    let info: [Enrollment]
}
