//
//  FloatingActionButtonView.swift
//
//
//  Created by Abdulrasaq on 03/08/2023.
//

import SwiftUI
struct TestFab : View {
    var body: some View {
        List(0..<20) { number in
            Text("\(number)")
        }
        .attachFab(backgroundColor: .red) {
            //
        }
    }
}
public struct FloatingActionButtonView: View {
    @State var backgroundColor:Color = .green
    @State var onClick: () -> Void = {}
    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    onClick()
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .padding(7)
                }
                .padding(.horizontal, 30)
                .padding(.vertical)
                .background(
                    Circle()
                        .fill(backgroundColor)
                        .shadow(radius: 5, y: 10)
                )
                .padding()
            }
        }
    }
}

#Preview {
    TestFab()
}

public struct FabViewModifier: ViewModifier {
    @State var backgroundColor:Color = .green
    @State var onClick: () -> Void
    public init(backgroundColor: Color, onClick: @escaping () -> Void) {
        self._backgroundColor = State(initialValue: backgroundColor)
        self.onClick = onClick
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            FloatingActionButtonView(backgroundColor: backgroundColor, onClick: onClick)
        }
    }
  
}

