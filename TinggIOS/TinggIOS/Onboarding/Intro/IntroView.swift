//
//  IntroView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 23/06/2022.
//

import SwiftUI
import Theme
struct IntroView: View {
    @EnvironmentObject var theme: EnvironmentUtils
    var body: some View {
        VStack {
            TabView {
                ForEach(onboardingItems(), id: \.info) { item in
                    OnboadingView(onboadingItem: item)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            Button {
                print("Tapped")
            } label: {
                Text("Get started")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(theme.primaryTheme.primaryColor)
                    .cornerRadius(10)
                    .padding(30)
            }
        }.edgesIgnoringSafeArea(.all)
        .onAppear {
            setPageIndicatorAppearance()
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
            .environmentObject(EnvironmentUtils())
    }
}

extension IntroView {
    func setPageIndicatorAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
    }
}
