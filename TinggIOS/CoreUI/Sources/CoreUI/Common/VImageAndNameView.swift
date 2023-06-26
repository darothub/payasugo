//
//  VImageAndNameView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
public struct VImageAndNameView: View {
    @State var title: String = ""
    @State var imageUrl: String
    @State var useInitials = false
    var initials: String {
        if title == "None" || title.isEmpty {
            return "NA"
        } else {
            return title.prefix(2).uppercased()
        }
    }

    public init(title: String, imageUrl: String, useInitials: Bool = false) {
        _title = State(initialValue: title)
        _imageUrl = State(initialValue: imageUrl)
        _useInitials = State(initialValue: useInitials)
    }

    public var body: some View {
        VStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.black)

            } placeholder: {
                ProgressView()
                    .foregroundColor(.black)
                    .showIfNot($useInitials)

                Text(initials)
                    .foregroundColor(.black)
                    .showIf($useInitials)
            }
            .frame(width: 30,
                   height: 30,
                   alignment: .center)
            .padding(30)
            .background(Color(UIColor(hex: "#aaaaaa")))
            .clipShape(Circle())

            Text(title.isEmpty ? initials : title)
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
        HStack(alignment: .top) {
            VImageAndNameView(title: "", imageUrl: "https://c8.alamy.com/comp/2HMGGJB/airtel-logo-2HMGGJB.jpg")
            VImageAndNameView(title: "Safaricom airtime", imageUrl: "https://mula.co.ke/mula_ke/api/v1/images/icons/tingg4_icons/airtime.png")
        }
    }
}

extension UIColor {
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}
