//
//  ActiveCategoryView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//

import SwiftUI
import Theme

struct ActiveCategoryView: View {
    var title: String = ""
    var body: some View {
        VStack {
            Image(systemName: "camera.fill")
                .frame(width: 65,
                       height: 65,
                       alignment: .center)
                .scaleEffect(1)
                .foregroundColor(PrimaryTheme.getColor(.cellulantRed))
                .background(PrimaryTheme.getColor(.cellulantRed).opacity(0.08))
                .clipShape(Circle())
                .padding(10)
                .shadow(radius: 3)
            Text("Category \(title)")
                .font(.caption)
        }
    }
}

struct ActiveCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCategoryView()
    }
}
