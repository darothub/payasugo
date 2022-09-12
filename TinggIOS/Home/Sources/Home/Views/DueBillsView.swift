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
    @State var updatedTimeString: String = ""
    var body: some View {
        Section {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    PrimaryTheme.getImage(image: .tinggAssistImage)
                        .resizable()
                        .frame(width: 35, height: 35)
                    tinggAssistAndBillText()
                }
                ForEach(fetchedBill, id: \.billReference) { bill in
                    let now = Date()
                    let dueDate = makeDateFromString(validDateString: bill.dueDate)
                    let dueDays = dueDate - now
                    let dueDaysString = dueDayString(dueDaysNumber: dueDays.day)
                    
                    DueBillCardView(serviceName: bill.biller, serviceImageString: "", beneficiaryName: bill.customerName, accountNumber: bill.billReference, amount: bill.currency+"0.0", dueDate: dueDaysString, updatedTimeString: $updatedTimeString)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(radius: 3, x: 0, y: 3)
                        )
                }
              
            }.padding()
        }
    }
    @ViewBuilder
    func tinggAssistAndBillText() -> some View {
        VStack(alignment: .leading) {
            Text("Tingg Assist")
                .bold()
                .foregroundColor(.black)
            Text("You have due bills")
                .font(.caption)
                .foregroundColor(.black)
        }
    }
    func dueDayString(dueDaysNumber: Int) -> String {
        print("Number \(dueDaysNumber)")
        if dueDaysNumber < 0 {
            return "\(abs(dueDaysNumber)) day(s) ago"
        }
        else if dueDaysNumber == 0 {
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
        DueBillsView()
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
    @Binding var updatedTimeString: String
    var body: some View {
        HStack {
            Rectangle()
                     .fill(Color.red)
                     .frame(width: 10, height: 90)
                     .cornerRadius(20, corners: [.topRight, .bottomRight])
            LeftHandSideView(serviceName: serviceName, serviceImageString: serviceImageString, beneficiaryName: beneficiaryName, accountNumber: accountNumber, updatedTimeString: $updatedTimeString)
            Spacer()
            RightHandSideView(amount: amount, dueDate: dueDate)
        }.frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
    }
}
struct LeftHandSideView: View {
    @State var serviceName: String = ""
    @State var serviceImageString = ""
//    @State var updatedTime = ""
    @State var beneficiaryName = ""
    @State var accountNumber = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var updatedTime: Int = 0
    @Binding var updatedTimeString: String
    var body: some View {
        HStack(alignment: .top) {
            RemoteImageCard(imageUrl: serviceImageString)
            VStack(alignment: .leading) {
                Text("\(serviceName)")
                    .bold()
                    .font(.caption)
                    .foregroundColor(.black)
                Text("Updated at: \(updatedTimeString)")
                    .font(.caption)
                    .foregroundColor(.black)
                Text("\(beneficiaryName)")
                    .bold()
                    .textCase(.uppercase)
                    .font(.caption)
                    .foregroundColor(.black)
                Text("Acc No: \(accountNumber)")
                    .font(.caption)
                    .foregroundColor(.black)
            }
        }.onReceive(timer) { latest in
            updatedTime += 1
            updatedTimeString = updatedTimeInUnits(time: updatedTime)
        }
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
                .foregroundColor(.black)
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