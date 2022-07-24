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
    @ObservedResults(Categorys.self, where: {$0.activeStatus == "1"}) var categories
    @StateObject var homeViewModel = HomeViewModel()
    var body: some View {
        TabView {
            ForEach(0..<homeViewModel.chunk2.count, id: \.self) { eachChunk in
                HStack(alignment: .top) {
                    ForEach(homeViewModel.chunk2[eachChunk], id: \.categoryID) { eachCategory in
                        if let name = eachCategory.categoryName, let logo = eachCategory.categoryLogo {
                            ActiveCategoryView(
                                title: name,
                                imageUrl: logo
                            )
                        }
                    }
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
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

class HomeViewModel: ObservableObject {
    @ObservedResults(Categorys.self, where: {$0.activeStatus == "1"}) var categories
    @Published var chunk2 = [[Categorys]]()
    init() {
       chunk2 = categories.reversed().reversed().chunked(into: 4)
    }
}
