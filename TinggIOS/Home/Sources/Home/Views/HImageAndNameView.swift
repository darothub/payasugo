//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 12/10/2022.
//

import SwiftUI
import Theme
struct HImageAndNameView: View {
    @State var text: String = "test"
    @State var image: Image?
    @State var name: String = ""
    var body: some View {
        HStack {
            if image == nil {
                let initials = text.prefix(2).uppercased()
                Text(initials)
                    .padding()
                    .background(.gray)
                    .clipShape(Circle())
                    .scaleEffect(0.85)
            } else {
                image?.resizable()
                    .frame(width: 45, height: 45, alignment: .leading)
                    .scaledToFit()
                    .background(.gray)
                    .clipShape(Circle())
                    .padding(.horizontal, 5)
            }
            Text(text)
                .font(.title2)
                .foregroundColor(.black)
            Spacer()
        }
    }
}

struct HImageAndNameView_Previews: PreviewProvider {
    static var previews: some View {
        HImageAndNameView()
    }
}
