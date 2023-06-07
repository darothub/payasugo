//
//  ActiveCategoryTabView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Combine
import CoreUI
import Core
import Foundation
import SwiftUI
import Photos
struct ActiveCategoryTabView: View {
    @StateObject var homeViewModel = HomeDI.createHomeViewModel()
    @State var categories: [[CategoryEntity]] = [[CategoryEntity]]()
    @State var show = true
    var body: some View {
        TabView {
            ForEach(0..<categories.count, id: \.self) { eachChunkIndex in
                ActiveCategoryListView(categories: categories[eachChunkIndex])
            }
        }
        .frame(height: 165)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .showIf($show)
        .onAppear {
            setPageIndicatorAppearance()
            homeViewModel.getServicesByCategory()
        }
        .handleViewStatesMods(uiState: homeViewModel.$categoryUIModel) { content in
            withAnimation {
                categories = content.data as? [[CategoryEntity]] ?? []
                show = categories.isNotEmpty()
            }
          
        }
    }
}

struct ActiveCategoryTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryTabView(categories: previewProcessedCategories)
    }
}

var previewProcessedCategories: [[CategoryEntity]] {
    let list = [
        previewCategories,
        previewCategories,
        previewCategories
    ]
    return list
}


