//
//  ActiveCategoryListView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Core
import SwiftUI
struct ActiveCategoryListView: View {
    @State var categories = [Categorys]()
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
    var body: some View {
        HStack(alignment: .top) {
            ForEach(categories, id: \.categoryID) { eachCategory in
                if let name = eachCategory.categoryName, let logo = eachCategory.categoryLogo {
                    VImageAndNameView(
                        title: name,
                        imageUrl: logo
                    ).onTapGesture {
                        if eachCategory.categoryID == "2" {
                            withAnimation {
                                navigation.navigationStack = [.home, .buyAirtime]
                            }
                        }
                    }
                }
            }
        }
    }
    fileprivate func onEachCategoryClick(categoryId: String) {
        switch categoryId {
        case "2":
            withAnimation {
                navigation.navigationStack = [.home, .buyAirtime]
            }
        default:
            withAnimation {
                navigation.navigationStack = [.home, .buyAirtime]
            }
        }
    }
}
struct ActiveCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryListView(categories: previewCategories)
    }
}

var previewCategories: [Categorys] {
    let catergory = Categorys()
    catergory.categoryID = "0"
    catergory.categoryName = "Test"
    let categories = [
        catergory,
        catergory,
        catergory,
        catergory
    ]
    return categories
}
