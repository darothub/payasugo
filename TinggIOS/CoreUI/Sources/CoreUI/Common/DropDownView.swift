//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 13/09/2022.
//

import SwiftUI

/// Custom drop down menu view
public struct DropDownView: View {
    @Binding var selectedText: String
    @Binding var dropDownList:[String]
    @Binding var showDropDown: Bool
    @State var rowColor: Color
    @State var outlineColor: Color
    @State var selectedTextColor: Color
    @State var label: String
    @State var placeHolder: String
    @State var showLabel = false
    @State var disableEdit = false
    public init(selectedText: Binding<String>, dropDownList: Binding<[String]>, showDropDown: Binding<Bool> = .constant(false), rowColor: Color = .white, outlineColor: Color = .black, selectedTextColor: Color = .black, label: String = "", showLabel: Bool = false, placeHoder: String = "Enter",
        lockTyping: Bool = false
    ) {
        self._selectedText = selectedText
        self._dropDownList = dropDownList
        self._showDropDown = showDropDown
        self._rowColor = State(initialValue: rowColor)
        self._outlineColor = State(initialValue: outlineColor)
        self._selectedTextColor = State(initialValue: selectedTextColor)
        self._label = State(initialValue: label)
        self._placeHolder = State(initialValue: placeHoder)
        self._disableEdit = State(initialValue: lockTyping)
    }
    public var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .showIf($showLabel)
                    .onAppear {
                        showLabel = !label.isEmpty
                    }
                HStack {
                    TextField(placeHolder, text: $selectedText)
                        .disabled(disableEdit)
                        .padding([.horizontal, .vertical], 17)
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
                        .onTapGesture {
                            withAnimation {
                                showDropDown.toggle()
                            }
                        }
                        .padding()
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 0.5)
                )
                .foregroundColor(outlineColor)
                .background(.white)
            }
            VStack(alignment: .leading) {
                List {
                    ForEach(dropDownList, id: \.self) { number in
                        VStack(alignment: .leading) {
                            Text("\(number)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding()
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        .listRowInsets(EdgeInsets())
                        .background(rowColor)
                        .onTapGesture {
                            selectedText = "\(number)"
                            withAnimation {
                                showDropDown.toggle()
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(.white)
                .scrollContentBackground(.hidden)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 5)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 0.5)
            }
            .hideIf(isHidden: $showDropDown)
        }
        .background(.white)
        .onAppear {
            showLabel = !label.isEmpty
        }
    }
}

struct DropDownView_Previews: PreviewProvider {
    struct DropDownViewHolder: View {
        @State var text = "Number"
        @State var list = ["egg", "liver", "cassava", "tomato", "pomato", "lomato"]
        @State var show = false
        var body: some View {
            DropDownView(selectedText: $text, dropDownList: $list, showDropDown: $show)
        }
    }
    static var previews: some View {
        DropDownViewHolder()
    }
}

