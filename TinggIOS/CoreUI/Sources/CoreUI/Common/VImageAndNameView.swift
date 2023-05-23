//
//  VImageAndNameView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
public struct VImageAndNameView: View {
    @State var title: String = ""
    @State var imageUrl: String = ""
    var initials: String {
        if title == "None" {
            return "NA"
        } else {
            return title.prefix(2).uppercased()
        }
    }
    public init(title: String, imageUrl: String) {
        self._title = State(initialValue: title)
        self._imageUrl = State(initialValue: imageUrl)
    }
    public var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.black)
                    .frame(width: 20,
                           height: 30,
                           alignment: .center)
                    .padding(15)
            } placeholder: {
                if initials.isEmpty {
                    ProgressView()
                        .clipShape(Circle())
                        .scaleEffect(1.3)
                        .padding()
                        .shadow(radius: 3)
                } else {
                    Text(initials)
                        .padding()
                        .background(.gray)
                        .clipShape(Circle())
                        .scaleEffect(1.3)
                        .padding()
                        .shadow(radius: 3)
                }
            }
            .padding(5)
            .background(.green.opacity(0.3))
            .clipShape(Circle())
            
            Text(title)
                .frame(width: 65, alignment: .center)
                .font(.caption)
                .foregroundColor(.black)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
            
        }
    }
}

struct VImageAndNameView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            VImageAndNameView(title: "", imageUrl: "")
            VImageAndNameView(title: "Safaricom airtime", imageUrl: "https://mula.co.ke/mula_ke/api/v1/images/icons/tingg4_icons/airtime.png")
        }
    }
}
