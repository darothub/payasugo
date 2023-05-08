//
//  AboutView.swift
//  
//
//  Created by Abdulrasaq on 03/05/2023.
//

import Core
import SwiftUI
import Theme
struct AboutView: View {
    @State private var termOfAgreementLink = "[Terms of Agreement](https://cellulant.io)"
    @State private var privacyPolicy = "[Privacy Policy](https://cellulant.io)"
    @State private var facebookLink = "https://facebook.com"
    @State private var twitterLink = "https://twitter.com"
    var body: some View {
        VStack {
            Text(.init(privacyPolicy)).underline()
            + Text(" and ")
            + Text(.init(termOfAgreementLink))
                .underline()
            HStack {
                Link(destination: URL(string: facebookLink)!) {
                    PrimaryTheme.getImage(image: .facebook)
                }
                Link(destination: URL(string: twitterLink)!) {
                    PrimaryTheme.getImage(image: .twitter)
                }
            }
            .padding()
            .scaleEffect(2)
            .padding()
            Text("Version ") + Text("4.1.76").underline()
            Spacer()
        }.onAppear {
            let countriesExtra = AppStorageManager.getCountriesExtraInfo()
            let tacUrl: String = countriesExtra?.tacURL.toString ?? "https://cellulant.io"
            let ppUrl: String = countriesExtra?.privacyPolicyURL.toString ?? "https://cellulant.io"
            privacyPolicy = "[Privacy Policy](\(ppUrl))"
            termOfAgreementLink = "[Terms and Conditions](\(tacUrl))"
            let contact = Observer<Contact>().getEntities().first
            facebookLink = contact?.facebook ?? "https://facebook.com"
            twitterLink = contact?.twitter ?? "https://twitter.com"
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
