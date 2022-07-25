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
    @State var index: Int = 0
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        HStack(alignment: .top) {
            ForEach(homeViewModel.processedCategories[index], id: \.categoryID) { eachCategory in
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
