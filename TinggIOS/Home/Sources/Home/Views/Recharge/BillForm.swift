//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 05/09/2022.
//

import SwiftUI
import Common
import Theme
import Core
struct BillFormView: View {
    @State var accountNumber: String = "080"
    @State var service: MerchantService = .init()
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .top) {
                    TopBackground()
                        .alignmentGuide(.top) { d in d[.bottom] * 0.75 }
                        .frame(height: geo.size.height * 0.2)
                    RemoteImageCard(imageUrl: service.serviceLogo!)
                        .scaleEffect(1.2)
                }
                Text(service.serviceName!)
                    .padding(20)
                    .font(.title.bold())
                    .foregroundColor(.black)
                
                TextFieldView(
                    accountNumber: $accountNumber,
                    service: $service
                )
                Spacer()
                
                button(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: "Continue"
                ) {
                    
                }
            }
        }
    }
}

struct BillFormView_Previews: PreviewProvider {
    static var previews: some View {
        BillFormView()
    }
}


struct TopBackground: View {
    var body: some View {
        Rectangle()
            .foregroundColor(.gray.opacity(0.3))
            .edgesIgnoringSafeArea(.all)
    }
}


struct TextFieldView: View {
    @Binding var accountNumber: String
    @Binding var service: MerchantService
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Enter your \(service.referenceLabel!)")
                    .font(.title3)
                    .foregroundColor(.black)
                TextField(service.referenceLabel!, text: $accountNumber)
                    .padding([.horizontal, .vertical], 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                    ).foregroundColor(.black)
                
            }.padding(.horizontal, 25)
        }
    }
}
