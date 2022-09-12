//
//  File.swift
//  
//
//  Created by Abdulrasaq on 08/09/2022.
//

import Foundation
import SwiftUI

@available(iOS 15, *)
public extension View {    
    func bottomSheet<Content: View>(
        present: Binding<Bool>,
        @ViewBuilder sheet: @escaping () -> Content
    ) -> some View {
        self.modifier(CustomBottomSheet(present: present, sheet: sheet))
    }
}

public struct CustomBottomSheet<Sheet: View>: ViewModifier {
    @Binding var present: Bool
    let sheet: () -> Sheet
    @State private var offset: CGFloat = UIScreen.main.bounds.height
    public init(present: Binding<Bool>, @ViewBuilder sheet: @escaping ()-> Sheet){
        self._present = present
        self.sheet = sheet
    }
    public func body(content: Content) -> some View {
        VStack {
            content
            sheet()
                .offset(y: offset)
                .animation(.spring(), value: offset)
                .onChange(of: present) { newValue in
                    print("Present changed \(newValue)")
                    offset = calculateOffset()
                    print("offset changed \(offset)")
                }
                .onAppear {
                    offset = calculateOffset()
                }
        }
    }
    
    private func calculateOffset() -> CGFloat {
        if present {
            return 0
        } else {
            return UIScreen.main.bounds.height
        }
    }
}


