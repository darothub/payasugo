//
//  TingIOSApp.swift
//  TingIOS
//
//  Created by Abdulrasaq on 25/05/2022.
//
import CreditCard
import Core
import CoreNavigation
import Checkout
import Permissions
import Home
import Onboarding
import SwiftUI
import Theme
import CoreUI
import FreshChat

@main
/// This is entry point into the application.
/// The first screen displayed to the user is the ``LaunchScreenView``.
/// The ``TinggIOSApp`` initialises the ``navigation`` and viewmodel

struct TinggIOSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.colorScheme) var colorScheme
    @StateObject var navigation = NavigationUtils()
    @StateObject var checkoutVm: CheckoutViewModel = CheckoutDI.createCheckoutViewModel()
    @StateObject var contactViewModel: ContactViewModel = .init()
    @StateObject var ccvm = CreditCardDI.createCreditCardViewModel()
    @StateObject var hvm = HomeDI.createHomeViewModel()
    @StateObject var mvm = MainViewModel(systemUpdateUsecase: .init(sendRequest: .shared))
    @StateObject private var freshchatWrapper = FreshchatWrapper()
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                .environmentObject(navigation)
                .environmentObject(checkoutVm)
                .environmentObject(contactViewModel)
                .environmentObject(ccvm)
                .environmentObject(hvm)
                .environmentObject(mvm)
                .environmentObject(freshchatWrapper)
                .sheet(isPresented: $checkoutVm.showView, onDismiss: {
                    checkoutVm.cancelPublishers()
                }) {
                    checkoutView()
                        .presentationDetents([.fraction(0.7)])
                        .presentationBackground(.thinMaterial)
                        .presentationContentInteraction(.scrolls)
                }
                .customDialog(
                    isPresented: $checkoutVm.showBundles,
                    backgroundColor: .constant(.clear),
                    cancelOnTouchOutside: .constant(true)
                ) {
                    BundleSelectionView(model: $checkoutVm.bundleModel)
                        .environmentObject(checkoutVm)

                }
                .onAppear {
                    UITextField.appearance().keyboardAppearance = .light
                    UITabBar.appearance().backgroundColor = colorScheme == .dark ? UIColor.white : UIColor.white

                    Log.d(message: FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!.path)
                
                        
                }
        }

    }
    func checkoutView() -> some View {
        return  CheckoutView()
            .environmentObject(checkoutVm)
            .environmentObject(contactViewModel)
            .environmentObject(navigation)
          
    }
    
    func showContactView() -> some View {
        return ContactRowView(listOfContactRow: contactViewModel.listOfContact.sorted(by: <)){contact in
            contactViewModel.selectedContact = contact.phoneNumber
        }
    }
}


@MainActor
class MainViewModel: ViewModel {
    @Published var homeViewModel = HomeDI.createHomeViewModel()
    @Published var appUiModel = UIModel.nothing
    var realmManager: RealmManager = .init()

    let systemUpdateUsecase: SystemUpdateUsecase
    
    /// Request for System update FSU
    public init(systemUpdateUsecase: SystemUpdateUsecase) {
        self.systemUpdateUsecase = systemUpdateUsecase
    }
    func fetchSystemUpdate() async  {
        let systemUpdateRequest: RequestMap =  RequestMap.Builder()
            .add(value: "PAR", for: .SERVICE)
            .build()
        homeViewModel.uiModel = UIModel.loading
        do {
            let response = try await systemUpdateUsecase(request: systemUpdateRequest)
            await saveDataIntoDB(data: try response.get())
            handleResultState(model: &homeViewModel.uiModel, response)
        } catch {
            handleResultState(model: &homeViewModel.uiModel, Result.failure(ApiError.networkError(error.localizedDescription)) as Result<BaseDTO, ApiError>)
        }
    }
    /// Save System  update response in database
    func saveDataIntoDB(data: SystemUpdateDTO) async  {
        
        let sortedCategories = data.categories.sorted { category1, category2 in
            category1.categoryID.convertStringToInt() < category2.categoryID.convertStringToInt()
        }.filter { category in
            category.isActive
        }.map { c in
            c.toEntity
        }
        realmManager.save(data: sortedCategories)
        realmManager.save(data: data.contactInfo.map {$0.toEntity})
        let services = data.services.filter { service in
            service.isActive
        }
        if let defaultNetworkServiceId = data.defaultNetworkServiceID {
            AppStorageManager.setDefaultNetworkId(id: defaultNetworkServiceId)
            let defaultNetwork = services.first { s in
                Log.d(message: "default \(defaultNetworkServiceId) \(s.hubServiceID.toInt)")
                return s.hubServiceID.toInt == defaultNetworkServiceId
            }
           
            if let service = defaultNetwork {
                AppStorageManager.setDefaultNetwork(service: service.toEntity)
            }
        }
        
        realmManager.save(data: services.map {$0.toEntity})
        realmManager.save(data: data.transactionSummaryInfo.map {$0.toEntity})
        let eligibleNomination = data.nominationInfo.filter { nom in
            nom.clientProfileAccountID?.toInt != nil
        }
        let validNomination = eligibleNomination.filter { e in
            return !e.isReminder.toBool && e.isActive
        }
        let validEnrollment = validNomination.map {$0.toEntity}
        realmManager.save(data: validEnrollment)
        let profile = data.mulaProfileInfo.mulaProfile[0]
        realmManager.save(data: profile.toEntity)
        realmManager.save(data: data.virtualCards.map {$0.toEntity})
        let payers: [MerchantPayer] = data.merchantPayers.map {$0.toEntity}
        realmManager.save(data: data.securityQuestions.map {$0.toEntity})
        realmManager.save(data: payers)

        realmManager.save(data: data.bundleData.map {$0.toEntity})
      
        AppStorageManager.retainCountriesExtraInfo(countrExtra: data.countriesExtraInfo)
    }
}
