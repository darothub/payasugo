//
//  CustomTabView.swift
//  
//
//  Created by Abdulrasaq on 20/09/2022.
//

import SwiftUI


/// Custom tab view
public struct CustomTabView<Content:View> : View {
    @Binding var tabColor: Color
    @State private var selectedTab = ""
    @Binding var items: [TabLayoutItem<Content>]
    /// ``CustomTabView`` initialiser
    /// - Parameters:
    ///   - items: List of tab layouts
    ///   - tabColor: tab color
    public init(items: Binding<[TabLayoutItem<Content>]>, tabColor: Binding<Color>, selectedTab: String = "") {
        self._tabColor = tabColor
        self._items = items
        self._selectedTab = State(initialValue: selectedTab)
    }
    public var body: some View {
        VStack {
            HStack(spacing: 0) {
                iTerateTabHeader()
            }
            TabView(selection: $selectedTab) {
                iTerateTabViews()
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .background(.white)
            
        }
        
    }
    private func iTerateTabHeader() -> some View {
        ForEach($items, id: \.title) { $tab in
            TabItemView(tabTitle: $tab.title, selected: $selectedTab, color: $tabColor)
        }
    }
    private func iTerateTabViews() -> some View {
        ForEach(items, id: \.title) { tabId in
            tabId.getContent()
        }
    }
}

public struct TabItemView: View {
    @Binding var tabTitle: String
    @Binding var selected: String
    @Binding var color: Color
    @State private var tabWidth = 100.0
    @State private var tabHeight = 50.0
    public var body: some View {
        Text(tabTitle)
            .font(.caption)
            .frame(maxWidth: .infinity, maxHeight: tabHeight)
            .background(
                Rectangle()
                    .foregroundColor(color)
                    .tag(tabTitle)
            )
            .foregroundColor(selected == tabTitle ? .white : .black)
            .onTapGesture {
                selected = tabTitle
            }
    }
}

public struct TabLayoutItem<Content: View> {
    var title: String
    var view : () -> Content
    public init(title: String, @ViewBuilder view: @escaping () -> Content = {AnyView(Text("Sample"))}) {
        self.title = title
        self.view = view
    }
    public mutating func setContent(content: @escaping () -> Content) {
        self.view = content
    }
    fileprivate func getContent() -> Content {
        return self.view()
    }
}

