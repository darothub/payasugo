//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 05/10/2022.
//
import Core
import SwiftUI
import Theme
struct AirtimeProviderListView: View {
    @Binding var selectedProvider: String
    @Binding var airtimeProviders: [MerchantService]
    @Binding var defaultNetworkId: String
    var onResetAccountNumber: () -> Void
    let gridColumn = [
        GridItem(.adaptive(minimum: 110))
    ]
    var body: some View {
        VStack(alignment: .leading) {
            Text("Select network provider")
                .font(.body)
                .padding(.top, 30)
            LazyVGrid(columns: gridColumn, spacing: 5){
                ForEach(0..<airtimeProviders.count, id: \.self) { index in
                    let service = airtimeProviders[index]
                    RectangleImageCardView(imageUrl: service.serviceLogo, tag: service.serviceName, selected: $selectedProvider) {
                        onResetAccountNumber()
                        }
                        .overlay(alignment: .topTrailing) {
                            if selectedProvider == service.serviceName {
                                onDefaultNetworkDetected(service: service)
                            }
                        }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(.white)
        .onAppear {
            print("AirtimeServices: \(airtimeProviders)")
        }
    }
    
    func onDefaultNetworkDetected(service: MerchantService) -> some View  {
        return NetworkFavouritedMarkedView().onAppear {
            selectedProvider = service.serviceName
        }
    }
}
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
        @State var services: [MerchantService] = .init()
        @State var selectedProvider = ""
        var body: some View {
            AirtimeProviderListView(
                selectedProvider: $selectedProvider,
                airtimeProviders: $services,
                defaultNetworkId: $defaultNetworkId
            ){
                resetAccountNumber()
            }
            .onAppear {
                let service1 = MerchantService()
                service1.serviceName = "Airtel"
                service1.hubServiceID = "1"
                service1.serviceLogo = "https://logoeps.com/wp-content/uploads/2012/10/airtel-logo-vector.png"
                let service2 = MerchantService()
                service2.serviceName = "Safaricom"
                service2.hubServiceID = "2"
                service2.serviceLogo = "https://d1yjjnpx0p53s8.cloudfront.net/styles/logo-thumbnail/s3/0021/8754/brand.gif?itok=vXzzoRXw"
                services =  [service1, service2]
            }
        }
        func resetAccountNumber() {
            print("Reset")
        }
    }
    static var previews: some View {
        AirtimeProviderPreview()
    }
}
