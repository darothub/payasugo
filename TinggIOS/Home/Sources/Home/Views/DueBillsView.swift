//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 22/08/2022.
//

import SwiftUI
import Theme
import Core
struct DueBillsView: View {
    @State var fetchedBill = [FetchedBill]()
    @StateObject var homeViewModel = HomeDI.createHomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                PrimaryTheme.getImage(image: .tinggAssistImage)
                    .resizable()
                    .frame(width: 35, height: 35)
                VStack(alignment: .leading) {
                    Text("Tingg Assist")
                        .bold()
                    Text("You have due bills")
                        .font(.caption)
                }
            }
            ForEach(fetchedBill, id: \.billReference) { bill in
                let now = Date()
                let updatedTime = updatedTimeInUnits(time: homeViewModel.updatedTime)
                let dueDate = makeDateFromString(validDateString: bill.dueDate)
                let dueDays = abs(dueDate - now)
                let dueDaysString = dueDayString(dueDaysNumber: dueDays.day)
                
                DueBillCardView(serviceName: bill.biller, serviceImageString: "", updatedTime: "\(updatedTime)", beneficiaryName: bill.customerName, accountNumber: bill.billReference, amount: bill.currency+"0.0", dueDate: dueDaysString)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 3, x: 0, y: 3)
                    )
            }
            .onReceive(homeViewModel.timer) { latest in
                homeViewModel.updatedTime += 1
            }
          
        }.padding()
    }
    func updatedTimeInUnits(time: Int) -> String {
      
        if time > 3599 {
            return "\(time / 3600) hours ago"
        }
        else if time > 59 {
            return "\(time / 60) mins ago"
        }
        else {
            return "\(time) seconds ago"
        }
    }
    
    func dueDayString(dueDaysNumber: Int) -> String {
        print("Number \(dueDaysNumber)")
        if dueDaysNumber < 1 {
            return "today"
        }
        else if dueDaysNumber == 1 {
            return "tomorrow"
        }
        else {
            return String(dueDaysNumber)+"days"
        }
    }
}

struct DueBillsView_Previews: PreviewProvider {
    static var previews: some View {
        DueBillCardView()
    }
}


struct DueBillCardView: View {
    @State var serviceName: String = ""
    @State var serviceImageString = ""
    @State var updatedTime = ""
    @State var beneficiaryName = ""
    @State var accountNumber = ""
    @State var amount = "0.0"
    @State var dueDate = "today"
    var body: some View {
        HStack {
            Rectangle()
                     .fill(Color.red)
                     .frame(width: 10, height: 90)
                     .cornerRadius(20, corners: [.topRight, .bottomRight])
            LeftHandSideView(serviceName: serviceName, serviceImageString: serviceImageString, updatedTime: updatedTime, beneficiaryName: beneficiaryName, accountNumber: accountNumber)
            Spacer()
            RightHandSideView(amount: amount, dueDate: dueDate)
        }.frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
    }
}
struct LeftHandSideView: View {
    @State var serviceName: String = ""
    @State var serviceImageString = ""
    @State var updatedTime = ""
    @State var beneficiaryName = ""
    @State var accountNumber = ""
    var body: some View {
        HStack(alignment: .top) {
            RemoteImageCard(imageUrl: serviceImageString)
            VStack(alignment: .leading) {
                Text("\(serviceName)")
                    .bold()
                    .font(.caption)
                Text("Updated at: \(updatedTime)")
                    .font(.caption)
                Text("\(beneficiaryName)")
                    .bold()
                    .textCase(.uppercase)
                    .font(.caption)
                Text("Acc No: \(accountNumber)")
                    .font(.caption)
            }
        }
    }
}
struct RightHandSideView: View {
    @State var amount = "0.0"
    @State var dueDate = "today"
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(amount)")
                .bold()
                .textCase(.uppercase)
                .font(.caption)
            Text("Due: \(dueDate)")
                .font(.caption)
                .foregroundColor(.red)
            Button {
                print("Pay your")
            } label: {
                Text("Pay")
                    .frame(width: 50)
                    .padding()
                    .foregroundColor(.white)
                    .textCase(.uppercase)
                    .font(.caption)
                    .background(.green)
                    .cornerRadius(25)
                   
            }
        }
    }
}


struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
