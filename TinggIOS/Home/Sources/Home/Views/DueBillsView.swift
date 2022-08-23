//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 22/08/2022.
//

import SwiftUI
import Theme
struct DueBillsView: View {
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
            DueBillCardView()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
                    .shadow(radius: 3, x: 0, y: 3)
                )
        }.padding()
    }
}


struct DueBillsView_Previews: PreviewProvider {
    static var previews: some View {
        DueBillsView()
    }
}


struct DueBillCardView: View {
    var body: some View {
        HStack {
            Rectangle()
                     .fill(Color.red)
                     .frame(width: 10, height: 90)
                     .cornerRadius(20, corners: [.topRight, .bottomRight])
            LeftHandSideView()
            Spacer()
            RightHandSideView()
        }.frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 10))
    }
}
struct LeftHandSideView: View {
    var body: some View {
        HStack(alignment: .top) {
            RemoteImageCard(imageUrl: "")
            VStack(alignment: .leading) {
                Text("ServiceName")
                    .bold()
                    .font(.caption)
                Text("Updated at: ")
                    .font(.caption)
                Text("Beneficiary Name")
                    .bold()
                    .textCase(.uppercase)
                    .font(.caption)
                Text("Acc No:")
                    .font(.caption)
            }
        }
    }
}
struct RightHandSideView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Amount")
                .bold()
                .textCase(.uppercase)
                .font(.caption)
            Text("Due date")
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
