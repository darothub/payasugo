//
//  VirtualCardHomeView.swift
//  
//
//  Created by Abdulrasaq on 17/04/2023.
//
import CoreUI
import Core
import Foundation
import SwiftUI

public struct VirtualCardHomeView: View {
    public var balance: String = ""
    public var currency = ""
    public var showManageCardLabel = false
    var action: () -> Void = {}
    public init(balance: String, currency: String = "KS", showManageCardLabel: Bool = false, action: @escaping () -> Void = {}) {
        self.balance = convertme(string: balance, with: currency)
        self.showManageCardLabel = showManageCardLabel
        self.action = action
    }
    public var body: some View {
        VStack(alignment: .leading, spacing: -40) {
            CardFrontLayoutView(showManageCardLabel: showManageCardLabel)
            HStack {
                VStack(alignment: .leading) {
                    Text("Available balance")
                    Text(balance)
                        .font(.system(size: 24))
                        .frame(width: 200, alignment: .leading)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .bold()
                }
          
                TinggOutlineButton(backgroundColor: .black, buttonLabel: "Fund card", padding: 5, textColor: .black, textHorPadding: 10) {
                    if showManageCardLabel {
                        action()
                    }
                }
                  
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.gray.opacity(0.2))
                    .padding(.horizontal)
            )
            Section {
                Text("Transactions")
                    .padding(.top, 80)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    .bold()
                TransactionListView(listOfModel: .constant([TransactionSectionModel.sample, .sample2]))
                    .padding(.horizontal, 10)
            }
        }
    }
}

struct SingleVirtualCardTransactionView: View {
    private var color: Color {
        switch model.status {
        case .success:
            return .green
        case .failed:
            return .red
        case .pending:
            return .orange
        }
    }
    var selectedColorForName: Color = .green

    @State var model: TransactionItemModel = TransactionItemModel.sample
    @State var onDeleteFlag: Bool = false
    @State private var isFullScreen = false
    @State private var view = AnyView(EmptyView())
    var body: some View {
        HStack(alignment: .top) {
            Text(model.accountName.prefix(2))
                .padding(5)
                .font(.title)
                .bold()
                .foregroundColor(selectedColorForName)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(selectedColorForName.opacity(0.5))
                )

            VStack(alignment: .leading) {
                Text("Service name")
                Text("Date")
                    .font(.subheadline)
            }
            Spacer()
            Text("Amount")
                .bold()
                .foregroundColor(color)
        }.padding(.vertical)
    }
}


