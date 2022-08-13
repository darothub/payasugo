//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 04/08/2022.
//
import Core
import Common
import SwiftUI
import Theme
struct PolicySectionView: View {
    @EnvironmentObject var onboardingViewModel: OnboardingViewModel
    @State var termOfAgreementLink = "[Terms of Agreement](https://cellulant.io)"
    @State var privacyPolicy = "[Privacy Policy](https://cellulant.io)"
    var body: some View {
        HStack(alignment: .top) {
            Group {
                CheckBoxView(checkboxChecked: $onboardingViewModel.isCheckedTermsAndPolicy)
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
            PolicySectionView()
                .environmentObject(OnboardingViewModel(
                    countryRepository: CountryRepositoryImpl(
                        apiService: BaseRepository(),
                        realmManager: RealmManager()
                    ),
                    baseRequest: BaseRequest(apiServices: BaseRepository())
                )
            )
        }
    }
    static var previews: some View {
        PolicySectionViewHolder()
    }
}
