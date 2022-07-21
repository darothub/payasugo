//
//  ActiveCategoryTabView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Common
struct ActiveCategoryTabView: View {
    var body: some View {
        TabView {
            ForEach(0..<2, id: \.self) { _ in
                VStack {
                    ActiveCategoryListView()
                    Spacer()
                }
            }
        }
        .frame(height: 165)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onAppear {
            setPageIndicatorAppearance()
        }
    }
}

struct ActiveCategoryTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryTabView()
    }
}
