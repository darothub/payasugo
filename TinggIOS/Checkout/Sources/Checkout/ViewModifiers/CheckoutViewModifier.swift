//
//  CheckoutViewModifier..swift
//
//
//  Created by Abdulrasaq on 05/08/2023.
//
import Core
import SwiftUI
import Foundation

public struct CheckoutViewModifier: ViewModifier {
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @Binding var showCheckoutView: Bool
    var checkoutListener: CheckoutListener
    @State private var sheetHeight: CGFloat = .zero
    public init(showCheckoutView: Binding<Bool>, checkoutListener: CheckoutListener) {
        self._showCheckoutView = showCheckoutView
        self.checkoutListener = checkoutListener
    }
    public func body(content: Content) -> some View {
        content
            .sheet(isPresented: $showCheckoutView, onDismiss: {
                sheetHeight = .zero
            }, content: {
                CheckoutView(listener: checkoutListener)
                    .environmentObject(checkoutVm)
                    .overlay {
                        GeometryReader { geometry in
                            Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
                        }
                    }
                    .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                        sheetHeight = newHeight
                    }
                    .presentationDetents([.height(sheetHeight)])
            })
           
    }
}


extension View {
    public func showCheckoutModifier(
        _ showCheckoutView: Binding<Bool>,
        checkoutListener: CheckoutListener
    ) -> some View {
        modifier(CheckoutViewModifier(showCheckoutView: showCheckoutView, checkoutListener: checkoutListener))
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
