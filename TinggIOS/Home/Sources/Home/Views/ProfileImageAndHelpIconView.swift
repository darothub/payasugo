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
    @State var imageUrl: String = ""
    var helpIconString =  "camera.fill"
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
            PrimaryTheme.getImage(image: .tinggAssistImage)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding()
        }
    }
}

struct ProfileImageAndHelpIconView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileImageAndHelpIconView()
    }
}
