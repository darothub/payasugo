//
//  ViewModifiers.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import SwiftUI
public extension View {
    @ViewBuilder
    func someShadow(showShadow: Binding<Bool>) -> some View {
        shadow(color: showShadow.wrappedValue ? .green : .red, radius: 1)
    }
    @ViewBuilder
    func someForegroundColor(condition: Binding<Bool>) -> some View {
        shadow(color: condition.wrappedValue ? .green : .red, radius: 1)
    }
    func customDialog<DialogContent: View>(
      isPresented: Binding<Bool>,
      @ViewBuilder dialogContent: @escaping () -> DialogContent
    ) -> some View {
      self.modifier(CustomDialog(isPresented: isPresented, dialogContent: dialogContent))
    }
    func handleViewState(
        uiModel: Binding<UIModel>
    ) -> some View {
      self.modifier(ViewState(uiModel: uiModel))
    }
    func setPageIndicatorAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
    }
    func tabItemStyle(title: String, image: Image?) -> some View {
        modifier(TabItemStyle(title: title, image: image))
    }
    @ViewBuilder
    func hiddenConditionally(isHidden: Binding<Bool>) -> some View {
        isHidden.wrappedValue ? self : self.hidden() as? Self
    }
}


public struct TabItemStyle: ViewModifier {
    public var title: String
    public var image: Image?
    public init(title: String, image: Image?){
        self.title = title
        self.image = image
    }
    public func body(content: Content) -> some View {
        content
            .tabItem {
                Label {
                    Text(title)
                } icon: {
                    image
                }
            }
    }
}
