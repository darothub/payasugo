//
//  ActiveCategoryView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Theme

struct ActiveCategoryView: View {
    @State var title: String = ""
    @State var imageUrl: String = ""
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                .frame(width: 65,
                       height: 65,
                       alignment: .center)
                .scaleEffect(1)
                .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
                .background(PrimaryTheme.getColor(.cellulantRed).opacity(0.08))
                .clipShape(Circle())
                .padding(10)
            } placeholder: {
                Image(systemName: "camera.fill")
                    .frame(width: 65,
                           height: 65,
                           alignment: .center)
                    .scaleEffect(1)
                    .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
                    .background(PrimaryTheme.getColor(.cellulantRed).opacity(0.08))
                    .clipShape(Circle())
                    .padding(10)
                    .shadow(radius: 3)
            }
            Text(title)
                .font(.caption)
            Spacer()
        }
    }
}

struct ActiveCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryView(title: "Hello", imageUrl: "https://mula.co.ke/mula_ke/api/v1/images/icons/internet.png")    }
}





