//
//  HomeView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 14/07/2022.
//

import SwiftUI
import Theme

struct HomeView: View {
    var theme: PrimaryTheme = .init()
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                topBackgroundDesign()
                VStack {
                    HStack {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding()
                          
                        Spacer()
                        Image(systemName: "camera.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding()
                          
                    }
                    Text("Welcome back, user")
                        .foregroundColor(.white)
                        .font(.system(size: theme.smallTextSize))
                    Text("What would you like to do?")
                        .foregroundColor(.white)
                        .font(.system(size: theme.largeTextSize))
                }
                    
                VStack {
                    ActivateCardView()
                        .padding(.vertical, 150)
                        .padding(.horizontal, 30)
                }
            }
        }
    }
    func topBackgroundDesign() -> some View {
        BottomCurve()
            .fill(theme.secondaryColor)
            .frame(width: .infinity, height: 250)
            .edgesIgnoringSafeArea(.all)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
