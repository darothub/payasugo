//
//  SavedBillListView.swift
//  
//
//  Created by Abdulrasaq on 21/06/2023.
//
import CoreUI
import SwiftUI
import RealmSwift
import Core

public struct SavedBillListView: View {
    @EnvironmentObject var billViewModel: BillViewModel
    @State private var savedBillItems: [DueBillItem] = [.init()]
    @Binding var showSavedBill: Bool
    @Binding var isLoading: Bool
    
    var action:(DueBillItem) -> Void = {bill in }
    public var body: some View {
        VStack(alignment: .leading) {
            Text("SAVED BILLS")
            ForEach(savedBillItems) { item in
                SavedBillRow(item: item)
                    .onTapGesture {
                        action(item)
                    }
            }
        }
        .padding()
        .showIf($showSavedBill)
        .handleViewStatesModWithCustomShimmer(
            uiState: billViewModel.$savedBillUIModel,
            shimmerView: AnyView(DueBillsShimmerView()),
            isLoading: $isLoading
        ) { content in
            savedBillItems = content.data as? [DueBillItem] ?? []
            showSavedBill = savedBillItems.isNotEmpty()
        }
    }
}

struct SavedBillListView_Previews: PreviewProvider {
    static var previews: some View {
        SavedBillListView(showSavedBill: .constant(true), isLoading: .constant(false))
            .environmentObject(BillsDI.createBillViewModel())
    }
}

struct SavedBillRow : View {
    @State var item: DueBillItem = .init()
    var body: some View {
        HStack {
            LeftHandSideSavedBillView(serviceName: item.serviceName, serviceImageString: item.serviceImageString, beneficiaryName: item.beneficiaryName)
            Spacer()
            RightHandSideSavedBillView(accountNumber: item.accountNumber)
        }
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
    }
}

struct LeftHandSideSavedBillView: View {
    @State var serviceName: String = ""
    @State var serviceImageString = ""
    @State var beneficiaryName = ""
 
    var body: some View {
        HStack {
            IconImageCardView(imageUrl: serviceImageString, radius: 10, scaleEffect: 1.5, x: 0, y: 2, shadowRadius: 2)
            VStack(alignment: .leading) {
                Text("\(serviceName)")
                    .bold()
                    .font(.caption)
                    .foregroundColor(.black)
                Text("\(beneficiaryName)")
                    .bold()
                    .textCase(.uppercase)
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }
    }
}

struct RightHandSideSavedBillView: View {
    @State var accountNumber = "0.0"
    @State var updatedTime: Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var updatedTimeString: String = ""

    var body: some View {
        VStack(alignment: .trailing) {
            Text("Updated: \(updatedTimeString)")
                .font(.caption)
                .foregroundColor(.black)
            Text("AC \(accountNumber)")
                .bold()
                .textCase(.uppercase)
                .font(.subheadline)
                .foregroundColor(.black)
        }
        .onReceive(timer) { latest in
            updatedTime += 1
            updatedTimeString = updatedTimeInUnits(time: updatedTime)
        }
    }
    public func updatedTimeInUnits(time: Int) -> String {
        if time > 3599 {
            return "\(time / 3600) hours ago"
        }
        else if time > 59 {
            return "\(time / 60) mins ago"
        }
        else {
            return "right now"
        }
    }
}
