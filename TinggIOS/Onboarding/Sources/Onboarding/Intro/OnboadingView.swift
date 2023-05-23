//
//  OnboadingView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//
import CoreUI
import Core
import SwiftUI
import Theme

/// A blue print of the Onboarding view
struct OnboadingView: View {
    @Environment(\.colorScheme) var colorScheme
    let onboadingItem: OnboardingItem
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack {
                    Spacer()
                    gifImage()
                        .frame(width: geo.size.width/1.5, height: geo.size.height/2)
                        .padding()
                        Spacer()
                    
                    pageIntro
                    pageSubIntro
                    Spacer()
                }
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
        }
    }
}

struct OnboadingView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            OnboadingView(onboadingItem: exampleOnboarding())
        }
    }
}

extension OnboadingView {
    /// To return a custom view that displays a gif Image
    /// - Parameter size: size of the image
    /// - Returns: A gif Image
    func gifImage() -> some View {
        let url = Bundle.module.url(forResource: onboadingItem.centerImage, withExtension: "gif")!
        return GifImage(url)
    }
    var pageIntro: some View {
        Text(onboadingItem.info)
            .font(.system(size: PrimaryTheme.mediumTextSize))
            .foregroundColor(.black)
            .bold()
            .multilineTextAlignment(.center)
            .padding(.vertical, 5)
            .accessibility(identifier: "nevermisstopay")
    }
    var pageSubIntro: some View {
        Text(onboadingItem.subInfo)
            .font(.system(size: PrimaryTheme.smallTextSize))
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .accessibility(identifier: "addyourbillontingg")
    }
}
