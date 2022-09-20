//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//
import Common
import SwiftUI

struct BillView: View {
    @State var color: Color = .green
    @State var items = [
        TabLayoutItem(title: "MY BILLS", view: AnyView(MyBillView())),
        TabLayoutItem(title: "RECEIPTS", view: AnyView(Text("RECEIPTS")))
    ]
    @EnvironmentObject var hvm: HomeViewModel
    var body: some View {
        VStack(spacing: 0) {
            ProfileImageAndHelpIconView(imageUrl: hvm.profile.photoURL!)
                .background(.green)
            CustomTabView(items: items, tabColor: $color)
        }
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
