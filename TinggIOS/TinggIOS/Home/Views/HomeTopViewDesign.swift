//
//  HomeTopViewDesign.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 17/07/2022.
//
import CoreUI
import Core
import SwiftUI
import Theme

struct HomeTopViewDesign: View {
    @EnvironmentObject var hvm: HomeViewModel
    @State var profileImageUrl: String = ""
    var onHamburgerIconClick: () -> Void
    var body: some View {
        VStack {
            HomeHeaderView(imageUrl: $profileImageUrl, onHamburgerIconClick: {
                onHamburgerIconClick()
            })
        }
        .background(
            PrimaryTheme.getColor(.secondaryColor)
        )
    }
}
struct HomeHeaderView: View {
    @Binding var imageUrl: String
    var helpIconString =  "camera.fill"
    @State var title: String = ""
    var titleColor: Color = .white
    @State private var hideTitle = false
    var onHamburgerIconClick: () -> Void
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            } placeholder: {
                Image(systemName: "line.horizontal.3")
                    .resizable()
                    .frame(width: 30, height: 20)
                    .padding()
                    .foregroundColor(.white)
            }.onTapGesture {
                onHamburgerIconClick()
            }
            Spacer()
            Text(title)
                .foregroundColor(titleColor)
                .hideIf(isHidden: $hideTitle)
            Spacer()
            PrimaryTheme.getImage(image: .tinggAssistImage)
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding()
        }.onAppear {
            hideTitle = title.isEmpty ? false : true
        }
    }
}
struct HomeTopViewDesign_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            HomeTopViewDesign(onHamburgerIconClick: {
                //
            })
                .environmentObject(HomeDI.createHomeViewModel())
        }
    }
}
var previewProfile: Profile {
    let prof = Profile()
    prof.firstName = "Test"
    prof.photoURL = ""
    return prof
}
