//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 13/09/2022.
//

import SwiftUI

public struct DropDownView: View {
    @Binding var selectedText: String
    @State var dropDownList = [String]()
    @State var showDropDown = false
    @State var rowColor: Color
    @State var outlineColor: Color
    @State var selectedTextColor: Color
    @State var label: String
    @State var placeHolder: String
    @State var showLabel = false
    public init(selectedText: Binding<String>, dropDownList: [String], rowColor: Color = .white, outlineColor: Color = .black, selectedTextColor: Color = .black, label: String = "", showLabel: Bool = false, placeHoder: String = "") {
        self._selectedText = selectedText
        self._dropDownList = State(initialValue: dropDownList)
        self._rowColor = State(initialValue: rowColor)
        self._outlineColor = State(initialValue: outlineColor)
        self._selectedTextColor = State(initialValue: selectedTextColor)
        self._label = State(initialValue: label)
        self._placeHolder = State(initialValue: placeHoder)
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group{
                Text(label)
                    .font(.caption)
                    .foregroundColor(.black)
                    .hiddenConditionally(isHidden: $showLabel)
                HStack {
                    TextField(placeHolder, text: $selectedText)
                        .padding([.horizontal, .vertical], 15)
                        .font(.caption)
                        .foregroundColor(selectedTextColor)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showDropDown.toggle()
                            }
                        }
                        .onChange(of: selectedText) { newValue in
                            showDropDown = false
                        }
                    Image(systemName: showDropDown ? "chevron.down" : "chevron.right")
                        .padding()
                } .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.5)
                ).foregroundColor(outlineColor)
            }
            ScrollView(showsIndicators: false){
                ForEach(dropDownList, id: \.self) { number in
                    VStack(alignment: .leading) {
                        Text("\(number)")
                            .padding(.horizontal)
                            .font(.caption)
                        Divider()
                    }
                    .background(rowColor.opacity(0.4))
                    .onTapGesture {
                        selectedText = "\(number)"
                        showDropDown.toggle()
                    }
                }
                .hiddenConditionally(isHidden: $showDropDown)
            }
        }.onAppear {
            showLabel = !label.isEmpty
        }
    }
}

struct DropDownView_Previews: PreviewProvider {
    struct DropDownViewHolder: View {
        @State var text = "Number"
        var body: some View {
            DropDownView(selectedText: $text, dropDownList: ["egg", "liver", "cassava", "tomato"])
        }
    }
    static var previews: some View {
        DropDownViewHolder()
    }
}

