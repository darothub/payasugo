//
//  CardFrontLayoutView.swift
//  
//
//  Created by Abdulrasaq on 04/04/2023.
//
import CoreUI
import Foundation
import SwiftUI

public struct CardFrontLayoutView: View {
    @State var dataModel: CardFrontDataModel = .init()
    @State var showManageCardLabel = true
    public init (dataModel: CardFrontDataModel = .init(), showManageCardLabel: Bool = true) {
        _dataModel = State(initialValue: dataModel)
        _showManageCardLabel = State(initialValue: showManageCardLabel)
    }
    public var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(dataModel.cardHolderName)
                Spacer()
                Text("Manage card")
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.green)
                    )
                    .showIf($showManageCardLabel)
            }.padding(.top, 20)
            VStack(alignment: .leading) {
                Text(dataModel.cardNumber)
                    .foregroundColor(.green)
                    .font(.title3)
                    .bold()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Expiry Date")
                            .font(.caption)
                        Text(dataModel.expiryDate)
                    }
                    VStack(alignment: .leading) {
                        Text("CVV")
                            .font(.caption)
                        Text(dataModel.cvv)
                    }
                }.padding(.top, 5)
            }.padding(.top, 65)
       
            HStack {
                Image("tinggwhitegreen")
                    .resizable()
                    .frame(width: 40, height: 20)
                Spacer()
                Image("mastercardlogo")
            } .padding(.bottom, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: 250)
        .foregroundColor(.white)
        .padding(30)
        .background(CardLayoutBackGroundView())
        .padding()
    }
}

struct CardLayoutBackGroundView: View {
    var body: some View {
        ZStack {
            Color.black
                .frame(height: 250)
                .cornerRadius(15)
            Image("africa")
                .resizable()
                .frame(height: 250)
        }
    }
}


public struct CardFrontDataModel {
    public var cardHolderName: String
    public var cardNumber: String
    public var expiryDate: String
    public var cvv: String
    public init(cardHolderName: String = "Cardholder's name", cardNumber: String = "0000 0000 0000 0000", expiryDate: String = "MM/YY", cvv: String = "123") {
        self.cardHolderName = cardHolderName
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cvv = cvv
    }
}
