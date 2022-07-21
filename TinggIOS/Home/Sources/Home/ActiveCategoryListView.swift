//
//  ActiveCategoryListView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Theme
struct ActiveCategoryListView: View {
    var body: some View {
        HStack {
            ForEach(0..<4, id: \.self) { ele in
                ActiveCategoryView(title: "\(ele)")
            }
        }
    }
}

struct ActiveCategoryListView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryListView()
    }
}
