//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 03/11/2022.
//
import Core
import SwiftUI

struct BillersView: View {
    @State var billers = [MerchantService]()
    let gridColumn = [
        GridItem(.adaptive(minimum: 150))
    ]
    var body: some View {
        viewBody()
    }
    
    @ViewBuilder
    fileprivate func viewBody() -> some View {
        LazyVGrid(columns: gridColumn, spacing: 0){
            ForEach(billers, id: \.id) { service in
                Item(name: service.serviceName, logo: service.serviceLogo)
                    .scaleEffect(1.5)
            }
        }
    }
}

struct BillersView_Previews: PreviewProvider {
    struct BillersViewHolder: View {
        var billers:[MerchantService]  {
            sampleServices
        }
        var body: some View {
            BillersView(billers: billers)
        }
    }
    static var previews: some View {
        BillersViewHolder()
        
    }
}
