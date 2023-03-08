//
//  ProfileImageAndHelpIconView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Core
import Theme
struct ProfileImageAndHelpIconView: View {
    @Binding var imageUrl: String
    var helpIconString =  "camera.fill"
    @State var title: String = ""
    var titleColor: Color = .white
    @State private var hideTitle = false
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            } placeholder: {
                PrimaryTheme.getImage(image: .tinggIcon)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            }
            Spacer()
            Text(title)
                .foregroundColor(titleColor)
                .hideIf(isHidden: $hideTitle)
            Spacer()
            PrimaryTheme.getImage(image: .tinggAssistImage)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding()
        }.onAppear {
            hideTitle = title.isEmpty ? false : true
        }
    }
}

struct ProfileImageAndHelpIconView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageAndHelpIconView(imageUrl: .constant(""))
    }
}
