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
import SwiftUI
import Photos
struct ActiveCategoryTabView: View {
    var categories: [[Categorys]] = [[Categorys]]()
    var body: some View {
        TabView {
            ForEach(0..<categories.count, id: \.self) { eachChunkIndex in
                ActiveCategoryListView(categories: categories[eachChunkIndex])
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
        ActiveCategoryTabView(categories: previewProcessedCategories)
    }
}

var previewProcessedCategories: [[Categorys]] {
    let list = [
        previewCategories,
        previewCategories,
        previewCategories
    ]
    return list
}


