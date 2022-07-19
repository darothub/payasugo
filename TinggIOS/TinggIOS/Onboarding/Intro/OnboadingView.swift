//
//  OnboadingView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI
import Theme

struct OnboadingView: View {
    let onboadingItem: OnboardingItem
    let screenSize: CGSize
    @EnvironmentObject var theme: EnvironmentUtils
    var body: some View {
        VStack {
            gifImage(size: screenSize)
            pageIntro
            pageSubIntro
        }
    }
}

struct OnboadingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboadingView(onboadingItem: exampleOnboarding(), screenSize: CGSize(width: 500, height: 500))
            .environmentObject(EnvironmentUtils())
    }
}

extension OnboadingView {
    func gifImage(size: CGSize) -> some View {
        GifImage(onboadingItem.centerImage)
            .frame(width: size.width * 0.6, height: size.height * 0.6, alignment: .center)
    }
    var pageIntro: some View {
        Text(onboadingItem.info)
            .font(.system(size: PrimaryTheme.mediumTextSize))
            .bold()
            .multilineTextAlignment(.center)
            .padding(.vertical, 5)
    }
    var pageSubIntro: some View {
        Text(onboadingItem.subInfo)
            .font(.system(size: PrimaryTheme.smallTextSize))
            .multilineTextAlignment(.center)
    }
}
