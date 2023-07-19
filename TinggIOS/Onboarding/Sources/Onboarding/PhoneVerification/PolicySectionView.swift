//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//
import Core
import CoreUI
import SwiftUI
import Theme

/// Part of the ``PhoneNumberValidationView`` for user to read and accept policies
struct PolicySectionView: View {
    @Binding var termOfAgreementLink : String
    @Binding var privacyPolicy : String
    @Binding var hasCheckedTermsAndPolicy: Bool
    var body: some View {
        HStack(alignment: .top) {
            Group {
                CheckBoxView(checkboxChecked: $hasCheckedTermsAndPolicy)
                    .accessibility(identifier: "policycheckbox")
                Text(.init("By proceeding you agree with the \(termOfAgreementLink) and \(privacyPolicy)"))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(.caption)
            .foregroundColor(PrimaryTheme.getColor(.tinggblack))
        }
    }
}

struct PolicySectionView_Previews: PreviewProvider {
    struct PolicySectionViewHolder: View {
        @State var termOfAgreementLink = "[Terms of Agreement](https://cellulant.io)"
        @State var privacyPolicy = "[Privacy Policy](https://cellulant.io)"
        var body: some View {
            PolicySectionView(
                termOfAgreementLink: $termOfAgreementLink,
                privacyPolicy: $privacyPolicy,
                hasCheckedTermsAndPolicy: .constant(false)
            )
        }
    }
    static var previews: some View {
        PolicySectionViewHolder()
    }
}
