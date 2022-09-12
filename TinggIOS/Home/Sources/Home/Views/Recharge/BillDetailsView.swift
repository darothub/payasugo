//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 06/09/2022.
//
import Common
import Theme
import SwiftUI
import Core

struct BillDetailsView: View {
    @State var fetchBill = FetchedBill()
    @State var service = MerchantService()
    @State var textFieldText = ""
    @State var amount = ""
    @State var dueDate = ""
    var dueDateComputed: String {
        let date = makeDateFromString(validDateString: fetchBill.estimateExpiryDate)
        return date.formatted(with: "EE, dd MM yyyy")
    }
    var amountComputed: String {
        fetchBill.currency + String(fetchBill.amount)
    }
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .top) {
                    TopBackground()
                        .alignmentGuide(.top) { d in d[.bottom] * 0.4 }
                        .frame(height: geo.size.height * 0.1)
                    RemoteImageCard(imageUrl: service.serviceLogo ?? "")
                        .scaleEffect(1.2)
                }
                Text(service.serviceName ?? "Service name")
                    .padding([.horizontal, .top], 20)
                    .font(.system(size: PrimaryTheme.mediumTextSize).bold())
                    .foregroundColor(.black)
                Text(fetchBill.billReference)
                    .font(.system(size: PrimaryTheme.smallTextSize))
                    .foregroundColor(.black)
                Group {
                    TextFieldView(
                        fieldText: $fetchBill.billReference,
                        label: service.referenceLabel ?? "Label",
                        placeHolder: service.referenceLabel!
                    )
                    TextFieldView(
                        fieldText: $fetchBill.customerName,
                        label: "Account name",
                        placeHolder: fetchBill.customerName
                    )
                    TextFieldView(
                        fieldText: $amount,
                        label: "Bill found",
                        placeHolder: amount
                    )
                    TextFieldView(
                        fieldText: $dueDate,
                        label: "Due date",
                        placeHolder: dueDate
                    )
                }.disabled(true)
                .padding(.top, 10)
                Spacer()
                HStack {
                    outlinebutton(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Save bill"
                    ) {
                        
                    }
                    button(
                        backgroundColor: PrimaryTheme.getColor(.primaryColor),
                        buttonLabel: "Pay bill"
                    ) {
                        
                    }
                }
            }
        }.onAppear {
            amount = amountComputed
            dueDate = dueDateComputed
        }
    }
}

struct BillDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        BillDetailsView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
