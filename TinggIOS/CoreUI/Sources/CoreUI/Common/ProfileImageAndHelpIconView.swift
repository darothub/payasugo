//
//  ProfileImageAndHelpIconView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Theme
public struct ProfileImageAndHelpIconView: View {
    @State var imageUrl: String
    @State var hideTitle = false
    @State var title: String = ""
    var helpIconString =  "camera.fill"
    var titleColor: Color = .white
    
    public init(imageUrl: String = "", helpIconString: String = "camera.fill", title: String = "", titleColor: Color  = .white, hideTitle: Bool = false) {
        self._imageUrl = State(initialValue:  imageUrl)
        self._title = State(initialValue: title)
        self.helpIconString = helpIconString
        self.titleColor = titleColor
        self.hideTitle = hideTitle
    }
    public var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            } placeholder: {
                Image(systemName: "photo")
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
        ProfileImageAndHelpIconView()
    }
}
