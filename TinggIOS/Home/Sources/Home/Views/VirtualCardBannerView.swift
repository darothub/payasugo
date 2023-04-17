//
//  VirtualCardBannerView.swift
//  
//
//  Created by Abdulrasaq on 03/04/2023.
//

import SwiftUI

public struct VirtualCardBannerView: View {
    public init() {
        //
    }
    public var body: some View {
        HStack(alignment: .bottom) {
            Image("virtualcardlogo")
                .resizable()
                .frame(width: 150, height: 110)
                .padding(.top)
                .alignmentGuide(.bottom) { d in
                    d[HorizontalAlignment.center] + 30
                }
            VStack(alignment: .leading) {
                Text("Make seamless\npayment online")
                Text("Create a virtual card")
                    .underline()
                    .padding(.top)
               
            }.font(.subheadline)
        }
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .shadow(radius: 3, x: 0, y: 5)
        )
    }
}

struct VirtualCardBannerView_Previews: PreviewProvider {
    static var previews: some View {
        VirtualCardBannerView()
    }
}


