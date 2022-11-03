//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 03/11/2022.
//
import Core
import SwiftUI

public struct BillersView: View {
    @State var billers = [MerchantService]()
    @State var enrolments = [Enrollment]()
    @State var title = ""
    
    public init( title: String, billers: [MerchantService], enrolments : [Enrollment]) {
        _title = State(initialValue: title)
        _billers = State(initialValue: billers)
        _enrolments = State(initialValue: enrolments)
        
    }
    public var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                viewBody()
                    .showIf(.constant(enrolments.isEmpty))
                    
            }
            Image(systemName: "plus")
                .padding(20)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .background(.green)
                .clipShape(Circle())
                .shadow(color: .gray, radius: 0.2, x: 1, y: 1)
                .padding(30)
                .scaleEffect(1)
        }
    }
    
    @ViewBuilder
    fileprivate func viewBody() -> some View {
        List {
            ForEach(billers, id: \.id) { service in
                NavigationLink(value: service) {
                    HStack {
                        RemoteImageCard(imageUrl: service.serviceLogo)
                            .scaleEffect(0.8)
                        Text(service.serviceName)
                    }
                }
            }
        }.navigationTitle(title)
    }
}

struct BillersView_Previews: PreviewProvider {
    struct BillersViewHolder: View {
        var billers:[MerchantService]  {
            sampleServices
        }
        var body: some View {
            BillersView(title: "Test", billers: billers, enrolments: .init())
                
        }
    }
    static var previews: some View {
        BillersViewHolder()
        
    }
}
