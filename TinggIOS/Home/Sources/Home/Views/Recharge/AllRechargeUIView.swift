//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 14/09/2022.
//

import SwiftUI

import SwiftUI

struct AllRechargeUIView: View {
    @State var selectedText = "Hello"
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack (alignment: .leading){
                Text("Add new bill")
                    .font(.title)
                    .foregroundColor(.black)
                SearchSection(selectedText: $selectedText)
            }.padding()
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
struct AllRechargeUIView_Previews: PreviewProvider {
    static var previews: some View {
        AllRechargeUIView()
    }
}

