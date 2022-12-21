//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 05/10/2022.
//
import Core
import SwiftUI
import Theme
struct RectangleImageCardView: View {
    @State var imageUrl: String = ""
    @State var tag: String = ""
    @State var radius: CGFloat = 5
    @State var y: CGFloat = 3
    @Binding var selected: String
    var onResetAccountNumber: () -> Void
    var body: some View {
        AsyncImage(url: URL(string: imageUrl)) { image in
            image.resizable()
                .frame(width: 100, height: 70)
                .clipShape(Rectangle())
                .padding(5)
        } placeholder: {
            PrimaryTheme.getImage(image: .tinggIcon)
                .frame(width: 100, height: 70)
                .clipShape(Rectangle())
                .padding(5)
        }.background(
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
                .shadow(color: .red, radius: selected == tag ? radius : 0, x: 0 , y: selected == tag ? y : 0)
        )
        .padding([.vertical, .horizontal], 5)
        .onTapGesture {
            withAnimation {
                selected = tag
                onResetAccountNumber()
            }
        }
    }
}

struct NetworkFavouritedMarkedView: View {
    var body: some View {
        Triangle()
            .fill(.purple)
            .frame(width: 40, height: 40)
            .cornerRadius(3, corners: [.topRight])
            .overlay(alignment: .topTrailing) {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .scaleEffect(0.7)
                    .padding(4)
                    .bold()
            }.padding(5)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}
struct AirtimeProviderListView_Previews: PreviewProvider {
    struct AirtimeProviderPreview: View {
        @State var defaultNetworkId = ""
        @State var services: [MerchantService] = sampleServices
        @State var selectedProvider = ""
        var body: some View {
            EmptyView()
        }
        func resetAccountNumber() {
            print("Reset")
        }
    }
    static var previews: some View {
        AirtimeProviderPreview()
    }
}
