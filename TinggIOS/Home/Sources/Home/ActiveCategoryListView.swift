//
//  ActiveCategoryListView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Core
import RealmSwift
import SwiftUI
import Theme
struct ActiveCategoryListView: View {
    @ObservedResults(Categorys.self, where: {$0.activeStatus == "1"}) var categories
    var body: some View {
        HStack {
            ForEach(0..<3, id: \.self) { index in
                let eachCategory = categories[index]
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

struct ActiveCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryListView()
    }
}
