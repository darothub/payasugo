//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//
import Common
import SwiftUI
import Theme
/// Shows a tab for users bills and receipt
public struct BillView: View {
    @EnvironmentObject var hvm: HomeViewModel
    @State var color: Color = .green
    @State var items = [
        TabLayoutItem(title: "MY BILLS", view: AnyView(MyBillView())),
        TabLayoutItem(title: "RECEIPTS", view: AnyView(Text("RECEIPTS")))
    ]
    var secondaryColor: Color {
        PrimaryTheme.getColor(.secondaryColor)
    }
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        VStack(spacing: 0) {
            ProfileImageAndHelpIconView(imageUrl: hvm.profile.photoURL!, title: "My Bills")
                .background(secondaryColor)
            CustomTabView(items: items, tabColor: $color)
        }.onAppear {
            color = secondaryColor
        }.environmentObject(hvm)
    }
}

struct BillView_Previews: PreviewProvider {
    static var previews: some View {
        BillView()
            .environmentObject(HomeDI.createHomeViewModel())
    }
}
