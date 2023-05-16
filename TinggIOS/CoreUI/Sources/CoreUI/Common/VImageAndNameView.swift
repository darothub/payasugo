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
            if imageUrl.isEmpty {
                Text(initials)
                    .padding()
                    .background(.gray)
                    .clipShape(Circle())
                    .scaleEffect(1.3)
                    .padding()
                    .shadow(radius: 3)
            } else {
                AsyncImage(url: URL(string: imageUrl)) { image in
                    image.resizable()
                    .frame(width: 65,
                           height: 65,
                           alignment: .center)
                    .foregroundColor(.red)
                    .background(.red.opacity(0.08))
                    .clipShape(Circle())
                    
                    .padding(10)
                } placeholder: {
                    Image(systemName: "person.fill")
                        .frame(width: 65,
                               height: 65,
                               alignment: .center)
                        .scaleEffect(1)
                        .foregroundColor(.red)
                        .background(.red.opacity(0.08))
                        .clipShape(Circle())
                        .padding(10)
                }
            }
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
            VImageAndNameView(title: "Safaricom airtime", imageUrl: "")
            VImageAndNameView(title: "Safaricom airtime", imageUrl: "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0022/3561/brand.gif?itok=oIhcrB6h")
        }
    }
}
