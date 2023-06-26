//
//  ActiveCategoryListView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import CoreUI
import Core
import CoreNavigation
import SwiftUI
//import RealmSwift

struct ActiveCategoryListView: View {
    @State var categories = [CategoryDTO]()
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var navigation: NavigationUtils
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach($categories, id: \.categoryID) { $eachCategory in
                VImageAndNameView(
                    title: eachCategory.categoryName,
                    imageUrl: eachCategory.categoryLogo
                )
                .scaleEffect(0.7)
                .onTapGesture {
                    onEachCategoryClick(categoryId: eachCategory.categoryID, categoryName: eachCategory.categoryName)
                }
            }
        }
    }
    fileprivate func onEachCategoryClick(categoryId: String, categoryName: String) {
        switch categoryId {
        case "2":
            if let defaultService = AppStorageManager.getDefaultNetwork() {
                withAnimation {
                    navigation.navigationStack.append(Screens.buyAirtime(defaultService.serviceName))
                }
            } else {
                Task {
                    let quickTopups = await hvm.getQuickTopups()
                    if let firstService = quickTopups.first {
                        withAnimation {
                            navigation.navigationStack.append(Screens.buyAirtime(firstService.serviceName))
                        }
                    }
                    
                }
          
            }
            
        default:
            let services = hvm.services.getEntities().filter {$0.categoryID == categoryId}
            let titleAndItemList = TitleAndListItem(title: categoryName, services: services)
            
            _ = hvm.nominationInfo.getEntities().filter {$0.serviceCategoryID == categoryId}
            withAnimation {
                navigation.navigationStack.append(
                    HomeScreen.billers(titleAndItemList)
                )
            }
        }
    }
}
struct ActiveCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryListView(categories: previewCategories.map {$0.toDTO})
    }
}

var previewCategories: [CategoryEntity] {
    let category = CategoryEntity()
    category.categoryID = "0"
    category.categoryName = "Test"
    category.categoryLogo = "https://logoeps.com/wp-content/uploads/2012/10/airtel-logo-vector.png"
    let category2 = CategoryEntity()
    category2.categoryID = "1"
    category2.categoryName = "Test"
    let category3 = CategoryEntity()
    category3.categoryID = "2"
    category3.categoryName = ""
    let category4 = CategoryEntity()
    category4.categoryID = "3"
    category4.categoryName = ""
    let categories = [
        category,
        category2,
        category3,
        category4
    ]
    return categories
}
