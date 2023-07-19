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
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State var categories: [[CategoryDTO]] = [[CategoryDTO]]()
    @State var show = true
    @State var isLoading = false
    var body: some View {
        TabView {
            ForEach(0..<categories.count, id: \.self) { eachChunkIndex in
                ActiveCategoryListView(categories: categories[eachChunkIndex])
                   
            }
            
        }
       
        .shadow(radius: 0, y: 1)
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .background(.white)
        .onAppear {
            setPageIndicatorAppearance()
        }
        .handleViewStatesModWithCustomShimmer(
            uiState: homeViewModel.$categoryUIModel,
            showAlertOnError: false,
            shimmerView: AnyView(HorizontalBoxesShimmerView()),
            isLoading: $isLoading
        ) { content in
            withAnimation {
                categories = content.data as? [[CategoryDTO]] ?? []
                show = categories.isNotEmpty()
            }
            
        } onFailure: { str in
            show = false
        }
        .showIf($show)
    }
}

struct ActiveCategoryTabView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryTabView(categories: previewProcessedCategories)
            .environmentObject(HomeDI.createHomeViewModel())
    }
}

var previewProcessedCategories: [[CategoryDTO]] {
    let p = previewCategories.map {$0.toDTO}
    let list = [
        p,
        p,
        p
    ]
    return list
}


import SwiftUI

struct ContentView: View {
    @State private var isSimmering = true
    
    var body: some View {
        VStack {
            Text("Simmering View")
                .font(.largeTitle)
                .opacity(isSimmering ? 0.2 : 1.0)
                .animation(Animation.easeInOut(duration: 1.0).repeatForever())
            
            Button(action: {
                isSimmering.toggle()
            }) {
                Text(isSimmering ? "Stop Simmering" : "Start Simmering")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
