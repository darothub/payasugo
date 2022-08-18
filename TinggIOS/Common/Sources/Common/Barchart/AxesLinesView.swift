//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 17/08/2022.
//

import SwiftUI
struct AxesLines: Shape {
    func path(in rect: CGRect) -> Path {
        Path() { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX , y: rect.maxY))
        }
    }
}

struct AxesLinesView: View {
    var body: some View {
       AxesLines()
            .stroke(.black, lineWidth: 6)
        
    }
}

struct AxesLinesView_Previews: PreviewProvider {
    static var previews: some View {
        AxesLinesView()
    }
}
