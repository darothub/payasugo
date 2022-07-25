//
//  ActiveCategoryTabView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Combine
import Common
import Core
import Foundation
import RealmSwift
import SwiftUI
struct ActiveCategoryTabView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        TabView {
            ForEach(0..<homeViewModel.processedCategories.count, id: \.self) { eachChunkIndex in
                ActiveCategoryListView(index: eachChunkIndex)
                    .environmentObject(homeViewModel)
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
            .environmentObject(HomeViewModel())
    }
}
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
