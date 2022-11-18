//
//  LaunchScreenView.swift
//  TinggIOS
//
//  Created by Abdulrasaq on 18/10/2022.
//

import Core
import Home
import Onboarding
import SwiftUI
import Theme
/// This view display the splash screen on launch.
///
/// This is the first screen  of ``TinggIOSApp``.
public struct LaunchScreenView: View {
    @EnvironmentObject var navigation: NavigationUtils
    @EnvironmentObject var ovm: OnboardingViewModel
    @EnvironmentObject var  hvm: HomeViewModel
    @State var colorTint:Color = .blue
    /// Creates a view that display the splash screen
    public init() {
        // Intentionally unimplemented...modular accessibility
    }
    public var body: some View {
        NavigationStack(path: $navigation.navigationStack) {
            ZStack {
                background
                image
                    .accessibility(identifier: "tinggsplashscreenlogo")
            }.onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    navigation.navigationStack = [.intro]
                }
            }
            .edgesIgnoringSafeArea(.all)
            .navigationDestination(for: Screens.self) { screen in
                switch screen {
                case .home:
                    HomeBottomNavView()
                case .intro:
                    IntroView()
                        .navigationBarHidden(true)
                        .environmentObject(navigation)
                        .environmentObject(ovm)
                case .buyAirtime:
                    BuyAirtimeView()
                case let .billers(billers):
                    BillersView(billers: billers)
                        .environmentObject(hvm)
                        .onAppear {
                            colorTint = .blue
                        }
                case .categoriesAndServices(let items):
                    CategoriesAndServicesView(categoryNameAndServices: items)
            
                case .billFormView(let billDetails):
                    BillFormView(billDetails: .constant(billDetails))
                        
                case let .nominationDetails(invoice, nomination):
                    NominationDetailView(invoice: invoice, nomination:  nomination)
                        .onAppear {
                            colorTint = .white
                        }
                case let .billDetailsView(invoice, service):
                    BillDetailsView(
                        fetchBill: invoice,
                        service: service
                    )
                }
            }
            
        }.changeTint($colorTint)
    }
}
/// Struct responsible for preview of changes in Xcode
struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(NavigationUtils())
            .environmentObject(OnboardingDI.createOnboardingViewModel())
            .environmentObject(HomeDI.createHomeViewModel())
    }
}

private extension LaunchScreenView {
    var background: some View {
        PrimaryTheme.getColor(.secondaryColor)
            .edgesIgnoringSafeArea(.all)
    }
    var image: some View {
        PrimaryTheme.getImage(image: .tinggSplashScreenIcon)
            .renderingMode(.template)
            .foregroundColor(Color.white)
    }
}

