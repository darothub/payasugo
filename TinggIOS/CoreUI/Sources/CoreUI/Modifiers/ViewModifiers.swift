//
//  ViewModifiers.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 13/07/2022.
//
import SwiftUI
import Combine
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
        modifier(ShadowBackground(color: color))
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
        modifier(CustomDialog(isPresented: isPresented, backgroundColor: backgroundColor, cancelOnTouchOutside: cancelOnTouchOutside, dialogContent: dialogContent))
    }

    func setPageIndicatorAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .green
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.gray.withAlphaComponent(0.2)
    }

    func tabItemStyle(title: String, image: Image?) -> some View {
        modifier(TabItemStyle(title: title, image: image))
    }

    @ViewBuilder
    func hideIf(isHidden: Binding<Bool>) -> some View {
        isHidden.wrappedValue ? self : hidden() as? Self
    }

    @ViewBuilder
    func showIf(_ value: Binding<Bool>) -> some View {
        value.wrappedValue ? self : hidden() as? Self
    }

    @ViewBuilder
    func showIfNot(_ value: Binding<Bool>) -> some View {
        !value.wrappedValue ? self : hidden() as? Self
    }

    @ViewBuilder
    func changeTint(_ value: Binding<Color>) -> some View {
        modifier(ChangeTint(color: value))
    }

    func textFiedStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }

    func validateBorderStyle(text: Binding<String>, validation: @escaping (String) -> Bool) -> some View {
        modifier(ValidatedBorderModifier(text: text, validation: validation))
    }

    func roundedBorder(color: Color = .black) -> some View {
        modifier(BorderModifier(borderColor: color))
    }

    func equatable<Content: View & Equatable>() -> EquatableView<Content> {
        return EquatableView(content: self as! Content)
    }

    func attachFab(backgroundColor: Color, onClick: @escaping () -> Void) -> some View {
        modifier(FabViewModifier(backgroundColor: backgroundColor, onClick: onClick))
    }


}

public struct TabItemStyle: ViewModifier {
    public var title: String
    public var image: Image?
    public init(title: String, image: Image?) {
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
        _color = color
    }

    public func body(content: Content) -> some View {
        content
            .tint(color)
    }
}

public struct EnableEditing: ViewModifier {
    @Binding public var enable: Bool
    public init(enable: Binding<Bool>) {
        _enable = enable
    }

    public func body(content: Content) -> some View {
        content
            .disabled(enable)
    }
}

public struct TextFiedValidationStyle: ViewModifier {
    @Binding var isValid: Bool
    @Binding var notValid: Bool
    public init(isValid: Binding<Bool>, notValid: Binding<Bool>) {
        _isValid = isValid
        _notValid = notValid
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

struct ValidatedTextFieldModifier: ViewModifier {
    @Binding var text: String
    @State private var isEditing = false
    private var validation: (String) -> Bool
    private var keyboardType: UIKeyboardType

    init(text: Binding<String>, validation: @escaping (String) -> Bool, keyboardType: UIKeyboardType = .default) {
        _text = text
        self.validation = validation
        self.keyboardType = keyboardType
    }

    func body(content: Content) -> some View {
        content
            .keyboardType(keyboardType)
            .onChange(of: text) { _ in
                isEditing = true
            }
    }

    private var borderColor: Color {
        if text.isEmpty {
            return .black
        } else {
            return isEditing ? (validation(text) ? .green : .red) : .black
        }
    }
}

struct ValidatedBorderModifier: ViewModifier {
    @Binding var text: String
    @State private var borderColor: Color = .black
    private var validation: (String) -> Bool

    init(text: Binding<String>, validation: @escaping (String) -> Bool) {
        _text = text
        self.validation = validation
    }

    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
            .onReceive(Just(text), perform: { newValue in
                if newValue.isEmpty {
                    borderColor = .black
                } else {
                    borderColor = validation(text) ? .green : .red
                }
            })
    }
}

struct BorderModifier: ViewModifier {
    var borderColor: Color = .black
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(borderColor, lineWidth: 1)
            )
    }
}
