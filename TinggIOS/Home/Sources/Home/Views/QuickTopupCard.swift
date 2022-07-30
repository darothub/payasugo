//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 30/07/2022.
//

import SwiftUI
import Theme
struct QuickTopupCard: View {
    @State var imageUrl: String = ""
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding()
        } placeholder: {
            PrimaryTheme.getImage(image: .tinggIcon)
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(60)
        }.background(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .shadow(radius: 3, x: 0, y: 3)
        )
    }
}

struct QuickTopupCard_Previews: PreviewProvider {
    static var previews: some View {
        QuickTopupCard()
    }
}
