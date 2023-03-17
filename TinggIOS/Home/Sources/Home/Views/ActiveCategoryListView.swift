//
//  ActiveCategoryListView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import Common
import Core
import SwiftUI
import RealmSwift
struct ActiveCategoryListView: View {
    @State var categories = [CategoryEntity]()
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
    var body: some View {
        HStack(alignment: .top) {
            ForEach(categories, id: \.categoryID) { eachCategory in
                if let name = eachCategory.categoryName, let logo = eachCategory.categoryLogo, let id = eachCategory.categoryID {
                    VImageAndNameView(
                        title: name,
                        imageUrl: logo
                    ).onTapGesture {
                        onEachCategoryClick(categoryId: id, categoryName: name)
                    }
                }
            }
        }
    }
    fileprivate func onEachCategoryClick(categoryId: String, categoryName: String) {
        switch categoryId {
        case "2":
            withAnimation {
                navigation.navigationStack = [.home, .buyAirtime]
            }
        default:
            let services = hvm.services.getEntities().filter {$0.categoryID == categoryId}
            let titleAndItemList = TitleAndListItem(title: categoryName, services: services)
            
            let enrolments = hvm.nominationInfo.getEntities().filter {$0.serviceCategoryID == categoryId}
            withAnimation {
                navigation.navigationStack = [
                    .home, .billers(titleAndItemList)
                ]
            }
        }
    }
}
struct ActiveCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryListView(categories: previewCategories)
    }
}

var previewCategories: [CategoryEntity] {
    let catergory = CategoryEntity()
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
