//
//  ShimmerUIViews.swift
//  
//
//  Created by Abdulrasaq on 21/06/2023.
//

import SwiftUI
import CoreUI
struct ShimmerUIViews: View {
    var body: some View {
        DueBillsShimmerView()
    }
}

struct ShimmerUIViews_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerUIViews()
    }
}


struct DueBillsShimmerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                BoxShimmerView(size: CGSize(width: 35, height: 35))
                VStack(alignment: .leading) {
                    TextShimmerView()
                    TextShimmerView(width: 80)
                }
                Spacer()
            }
            ForEach(0..<3, id: \.self) { n in
                DueBillCardShimmerView()
            }
        }
        .padding()
    }
    
}
struct RightHandSideShimmerView: View {
    var body: some View {
        VStack(alignment: .leading) {
            TextShimmerView()
            TextShimmerView()
            Button {
                //
            } label: {
                Text("")
                    .frame(width: 50)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .font(.caption)
                    .background(.gray)
                    .cornerRadius(25)
            }
            
        }
    }
}

struct LeftHandSideShimmerView: View {
    var body: some View {
        HStack {
            BoxShimmerView()
            VStack(alignment: .leading) {
                TextShimmerView()
                TextShimmerView()
                TextShimmerView()
                TextShimmerView()
            }
        }
    }
}

struct DueBillCardShimmerView: View {
    var body: some View {
        HStack {
            Rectangle()
                .fill(.gray)
                .frame(width: 10, height: 90)
                .cornerRadius(20, corners: [.topRight, .bottomRight])
            LeftHandSideShimmerView()
            Spacer()
            RightHandSideShimmerView()
        }
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
    }
}
