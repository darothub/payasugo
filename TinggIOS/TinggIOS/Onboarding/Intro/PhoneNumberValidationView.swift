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
    @State var isChecked = false
    @State var showSupportTeamContact = false
    let termOfAgreementLink = "[Terms of Agreement](https://cellulant.io)"
    let privacyPolicy = "[Privacy Policy](https://cellulant.io)"
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 10) {
                ZStack(alignment: .top) {
                    topRectangleBackground(geometry: geometry)
                    topCameraImage(geometry: geometry)
                }
                .frame(width: geometry.size.width, height: abs(geometry.size.height * 0.25))
                Text("Mobile Number")
                    .bold()
                    .padding(.leading, theme.largePadding)
                CountryCodesView()
                    .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1)
                            .foregroundColor(theme.cellulantRed)
                    )
                    .padding(.horizontal, theme.largePadding)
                Text("We'll send verification code to this number")
                    .bold()
                    .padding(.leading, theme.largePadding)
                HStack(alignment: .top) {
                    Group {
                        CheckBoxView(checkboxChecked: $isChecked)
                        Text("By proceeding you agree with the ")
                        + Text(.init(termOfAgreementLink))
                            .underline()
                        + Text(" and ") + Text(.init(privacyPolicy)).underline()
                    }.font(.system(size: theme.smallTextSize))
                }
                .padding(.horizontal, theme.largePadding)
                Spacer()
                Button {
                    showSupportTeamContact.toggle()
                } label: {
                    HStack {
                        Image(systemName: "phone.circle.fill")
                            .foregroundColor(Color.green)
                        Text("CONTACT TINGG SUPPORT TEAM")
                    }
                }.padding(.horizontal, 50)
                NavigationLink(destination: IntroView(), isActive: $isEditing) {
                    UtilViews.button(backgroundColor: theme.primaryColor, buttonLabel: "Continue") {
                        print("Continue")
                    }
                }
            }.navigationBarTitleDisplayMode(.inline)
                .popover(isPresented: $showSupportTeamContact) {
                    VStack {
                        Text("Call Ting Support")
                            .padding()
                        Text("Chat Ting Support")
                            .padding()
                    }
                }
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
            .foregroundColor(theme.cellulantRed)
            .background(.white)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 10))
            .shadow(radius: 3)
            .padding(.bottom, 10)
            .alignmentGuide(VerticalAlignment.top) { align in
                -align[VerticalAlignment.center] * 0.5
            }
    }
}
