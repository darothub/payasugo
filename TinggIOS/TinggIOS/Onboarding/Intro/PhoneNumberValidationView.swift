//
//  PhoneNumberValidationView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 26/06/2022.
//

import SwiftUI
import Theme

struct PhoneNumberValidationView: View {
   var theme = PrimaryTheme()
    @State var phoneNumber = ""
    @State var isEditing = false
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 40) {
                ZStack(alignment: .center) {
                    topRectangleBackground(geometry: geometry)
                    topCameraImage(geometry: geometry)
                }
                .frame(width: geometry.size.width, height: abs(geometry.size.height * 0.25))

                CountryCodesView()
                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                            .foregroundColor(theme.cellulantRed)
                    )
                    .padding(.all, 25)
                Spacer()
                NavigationLink(destination: IntroView(), isActive: $isEditing) {
                    UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Continue") {
                        print("Continue")
                    }
                }
            }.navigationBarHidden(true)
        }
    }
}

struct PhoneNumberValidationView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberValidationView()
            .environmentObject(EnvironmentUtils())
    }
}

extension PhoneNumberValidationView {
    fileprivate func topRectangleBackground(geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(theme.lightGray)
            .frame(width: geometry.size.width, height: abs(geometry.size.height * 1.4 * 0.25))
            .edgesIgnoringSafeArea(.all)
    }
    fileprivate func topCameraImage(geometry: GeometryProxy) -> some View {
        Image(systemName: "camera.fill")
            .frame(width: geometry.size.width * 0.21,
                   height: geometry.size.height * 0.1,
                   alignment: .center)
            .scaleEffect(1.5)
            .foregroundColor(.white)
            .background(.red)
            .clipShape(Circle())
            .shadow(radius: 3)
    }
}
