//
//  ActiveCategoryTabView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Combine
import Core
import Foundation
import SwiftUI
struct ActiveCategoryTabView: View {
    @State var processedCategories = [[Categorys]]()
    var body: some View {
        TabView {
            ForEach(0..<processedCategories.count, id: \.self) { eachChunkIndex in
                ActiveCategoryListView(categories: processedCategories[eachChunkIndex])
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
        ActiveCategoryTabView(processedCategories: previewProcessedCategories)
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

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
