//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 14/09/2022.
//

import SwiftUI
import Theme

struct AllRechargeUIView: View {
    @State var selectedText = "Hello"
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading){
                Text("Add new bill")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding()
                SearchSection(selectedText: $selectedText)
                    .padding()
                ForEach(0..<4, id: \.self) { row in
                    RowView()
                }
                   
            }
        }.background(.gray.opacity(0.1))
    }
}

struct SearchSection: View {
    @Binding var selectedText:String
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading)
                TextField("placeHolder", text: $selectedText)
                    .padding([.horizontal, .vertical], 15)
                    .font(.caption)
                    .foregroundColor(.black)
                  
            } .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.0)
            )  .background(.white)
            Image(systemName: "plus")
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.0)
                )  .background(.white)
        }
    }
}
struct RowView: View {
    @State var title = "Title"
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: PrimaryTheme.mediumTextSize))
                .foregroundColor(.black)
                .textCase(.uppercase)
            Item()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(.white)
                .shadow(radius: 3, x: 0, y: 3)
        )
    }
}

struct Item: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<4, id: \.self) { item in
                    RemoteImageCard(imageUrl: "")
                        .padding(.vertical)
                }
            }

        }
    }
}
struct AllRechargeUIView_Previews: PreviewProvider {
    static var previews: some View {
        AllRechargeUIView()
    }
}

