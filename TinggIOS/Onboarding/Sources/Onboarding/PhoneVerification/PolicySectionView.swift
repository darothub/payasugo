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
    @State var termOfAgreementLink = "[Terms of Agreement](https://cellulant.io)"
    @State var privacyPolicy = "[Privacy Policy](https://cellulant.io)"
    @Binding var hasCheckedTermsAndPolicy: Bool
    var body: some View {
        HStack(alignment: .top) {
            Group {
                CheckBoxView(checkboxChecked: $hasCheckedTermsAndPolicy)
                    .accessibility(identifier: "policycheckbox")
                Text("By proceeding you agree with the ")
                + Text(.init(termOfAgreementLink))
                    .underline()
                + Text(" and ") + Text(.init(privacyPolicy)).underline()
            }
            .font(.system(size: PrimaryTheme.smallTextSize))
            .foregroundColor(PrimaryTheme.getColor(.tinggblack))
        }
        .padding(.horizontal, PrimaryTheme.largePadding)
    }
}

struct PolicySectionView_Previews: PreviewProvider {
    struct PolicySectionViewHolder: View {
        var body: some View {
            PolicySectionView(hasCheckedTermsAndPolicy: .constant(false))
        }
    }
    static var previews: some View {
        PolicySectionViewHolder()
    }
}
