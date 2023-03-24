//
//  ViewModifiers.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import SwiftUI
public extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    @ViewBuilder
    func someShadow(showShadow: Binding<Bool>) -> some View {
        shadow(color: showShadow.wrappedValue ? .green : .red, radius: 1)
    }
    @ViewBuilder
    func shadowBackground(color: Color = .white) -> some View {
        self.modifier(ShadowBackground(color: color))
    }
    @ViewBuilder
    func someForegroundColor(valid: Binding<Bool>, notValid: Binding<Bool>) -> some View {
        foregroundColor(valid.wrappedValue ? .green : notValid.wrappedValue ? .red : .black)
    }
    func customDialog<DialogContent: View>(
      isPresented: Binding<Bool>,
      backgroundColor: Binding<Color> = .constant(.white),
      cancelOnTouchOutside: Binding<Bool> = .constant(false),
      @ViewBuilder dialogContent: @escaping () -> DialogContent
    ) -> some View {
        self.modifier(CustomDialog(isPresented: isPresented, backgroundColor: backgroundColor, cancelOnTouchOutside: cancelOnTouchOutside,  dialogContent: dialogContent))
    }
    @available(swift, deprecated: 5.0 , message: "This has been deprecated in build 6.0 v0.1.0 use handleViewStates instead")
    func handleViewState(
        uiModel: Binding<UIModel>
    ) -> some View {
      self.modifier(ViewState(uiModel: uiModel))
    }
    func handleViewStates(
        uiModel: Binding<UIModel>,
        showAlert: Binding<Bool>  = .constant(false),
        showSuccessAlert: Binding<Bool> = .constant(false),
        onSuccessAction: @escaping () -> Void = {},
        onErrorAction: @escaping () -> Void = {}
    ) -> some View {
      self.modifier(ViewStates(uiModel: uiModel, showAlert: showAlert, showSuccessAlert: showSuccessAlert, onSuccessAction: onSuccessAction, onErrorAction: onErrorAction))
    }
    func setPageIndicatorAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .red
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.red.withAlphaComponent(0.2)
    }
    func tabItemStyle(title: String, image: Image?) -> some View {
        modifier(TabItemStyle(title: title, image: image))
    }
    @ViewBuilder
    func hideIf(isHidden: Binding<Bool>) -> some View {
        isHidden.wrappedValue ? self : self.hidden() as? Self
    }
    @ViewBuilder
    func showIf(_ value: Binding<Bool>) -> some View {
        value.wrappedValue ? self : self.hidden() as? Self
    }
    @ViewBuilder
    func showIfNot(_ value: Binding<Bool>) -> some View {
        !value.wrappedValue ? self : self.hidden() as? Self
    }
    
    @ViewBuilder
    func changeTint(_ value: Binding<Color>) -> some View {
        self.modifier(ChangeTint(color: value))
    }
    func textFiedStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
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

public struct ShadowBackground: ViewModifier {
    public var color: Color = .white
    public init(color: Color) {
        self.color = color
    }
    public func body(content: Content) -> some View {
        content
            .background(
            Rectangle()
                .fill(color)
                .shadow(radius: 1, x: 1, y: 1)
        )
    }
}

public struct ChangeTint: ViewModifier {
    @Binding public var color: Color
    public init(color: Binding<Color>) {
        self._color = color
    }
    public func body(content: Content) -> some View {
        content
            .tint(color)
    }
}

public struct EnableEditing: ViewModifier {
    @Binding public var enable: Bool
    public init(enable: Binding<Bool>) {
        self._enable = enable
    }
    public func body(content: Content) -> some View {
        content
            .disabled(enable)
    }
}


public struct TextFiedValidationStyle: ViewModifier {
    @Binding var isValid: Bool
    @Binding var notValid: Bool
    public init(isValid: Binding<Bool>, notValid: Binding<Bool>){
        self._isValid = isValid
        self._notValid = notValid
    }
    public func body(content: Content) -> some View {
        content
            .padding(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
            .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: isValid ? 1 : notValid ? 1 : 0.5)
                .foregroundColor(isValid ? .green : notValid ? .red : .black)
            )
            .padding(.horizontal, 25)
    }
}
