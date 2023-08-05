//
//  BuyAirtimeView.swift
//
//
//  Created by Abdulrasaq on 27/09/2022.
//
import Checkout
import Contacts
import Core
import CoreNavigation
import CoreUI
import Permissions
import SwiftUI
import Theme

public struct BuyAirtimeView: View, OnDefaultServiceSelectionListener {
    @Environment(\.realmManager) var realmManager
    @StateObject var bavm: BuyAirtimeViewModel = AirtimeDI.createBuyAirtimeVM()
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @EnvironmentObject var navigation: NavigationManager
    @State private var showNetworkList = false
    @State private var networkList: [NetworkItem] = []
    @State public var selectedServiceName: String = ""
    @State private var airtimeServices: [MerchantService] = .init()
    @State private var disablePhoneNumberTextField = false
    @State private var isValidPhoneNumber = false
    @State private var isValidAmount = false
    @State var copyOfOldBeneficiaries = [PreviousBeneficiaryModel]()
    @State var currentCountry = AppStorageManager.getCountry()

    @FocusState var focused: String?
    public init(selectedServiceName: String) {
        _selectedServiceName = State(initialValue: selectedServiceName)
    }

    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                FavouriteListView(
                    currentPhoneNumber: $bavm.currentPhoneNumber,
                    beneficiaries: $bavm.oldBeneficiaries
                )
                Text("Mobile number")
                    .font(.subheadline)
                    .padding(.top)
                    .foregroundColor(.black)
                TextFieldAndRightIcon(
                    number: $bavm.currentPhoneNumber,
                    validation: { phoneNumber in
                        isValidPhoneNumber = validateWithRegex(bavm.countryMobileRegex, value: phoneNumber)
                        return isValidPhoneNumber
                    }, onImageClick: {
                        fetchContacts()
                    }).focused($focused, equals: contactViewModel.selectedContact)

                ServicesListView(slm: $bavm.slm, onClick: {
                    bavm.currentPhoneNumber = ""
                })
                WhoseNumberOptionView(selected: $bavm.whoseNumber)
                    .padding(.vertical)
                Group {
                    Text("Amount")
                        .font(.subheadline)
                        .padding(.top)
                        .foregroundColor(.black)
                    TextFieldAndLeftTitle(
                        number: $bavm.selectedAmount,
                        iconName: bavm.currency,
                        placeHolder: "Enter amount",
                        keyboardType: .numberPad
                    ) { amount in
                        isValidAmount = validateAmountByService(selectedService: bavm.currentService, amount: amount)
                        return isValidAmount
                    }.focused($focused, equals: bavm.selectedAmount)
                }
                SuggestedAmountListView(
                    amountHistory: $bavm.amountHistory,
                    amountSelected: $bavm.selectedAmount
                ).padding(.top)
                Spacer()
                TinggButton(
                    backgroundColor: PrimaryTheme.getColor(.primaryColor),
                    buttonLabel: "Buy airtime"
                ) {
                    onButtonClick()
                }
            }
            .padding()
            .background(.white)
            .onAppear {
                setServiceName(selectedServiceName)
                setCurrentService(bavm.getServiceByServiceName(bavm.slm.selectedProvider))

                airtimeServices = bavm.getAirtimeServices()
                bavm.enrollments = bavm.getEnrollments(to: bavm.currentService)
                setServiceModelFromServices(airtimeServices)

                setBeneficiariesFromEnrollments(bavm.enrollments)

                setAmountHistory(bavm.currentPhoneNumber)

                if let userDefaultNetwork = AppStorageManager.getDefaultNetwork() {
                    // Show network dialog if default network is not set
                    bavm.defaultService = userDefaultNetwork
                    if userDefaultNetwork.serviceName == selectedServiceName {
                        bavm.currentPhoneNumber = bavm.myPhoneNumber
                    }
                } else {
                    showNetworkList = true
                    bavm.networkList = getNetworkItems(bavm.slm.serviceModels)
                }
            }
            .customDialog(isPresented: $showNetworkList) {
                DialogContentView(
                    networkList: bavm.networkList,
                    phoneNumber: bavm.myPhoneNumber,
                    selectedServiceName: selectedServiceName,
                    listener: self
                )
                .padding()
                .handleViewStatesMods(uiState: bavm.$defaultNetworkUIModel) { _ in
                    setServiceName(bavm.defaultService.serviceName)
                    AppStorageManager.setDefaultNetworkId(id: bavm.defaultService.hubServiceID.convertStringToInt())
                    AppStorageManager.setDefaultNetwork(service: bavm.defaultService)
                    bavm.currentPhoneNumber = bavm.myPhoneNumber
                    showNetworkList = false
                } action: {
                    showNetworkList = false
                }
                .onDisappear {
                    bavm.defaultNetworkUIModel = UIModel.nothing
                }
            }
            .onChange(of: contactViewModel.selectedContact, perform: { newValue in
                bavm.currentPhoneNumber = newValue
            })
            .onChange(of: bavm.slm, perform: { newValue in
                guard let selectedService = filterServiceBySelectedServiceName(from: airtimeServices, name: newValue.selectedProvider) else {
                    return
                }
                setCurrentService(selectedService)
                bavm.enrollments = bavm.getEnrollments(to: bavm.currentService)
                setBeneficiariesFromEnrollments(bavm.enrollments)
                copyOfOldBeneficiaries = bavm.oldBeneficiaries
                if bavm.slm.selectedProvider == bavm.defaultService.serviceName {
                    bavm.whoseNumber = WhoseNumberLabel.my
                } else {
                    bavm.whoseNumber = WhoseNumberLabel.other
                }

            })
            .onChange(of: bavm.currentPhoneNumber, perform: { newValue in
                setAmountHistory(newValue)
                if newValue.isEmpty {
                    bavm.oldBeneficiaries = copyOfOldBeneficiaries
                } else {
                    bavm.oldBeneficiaries = copyOfOldBeneficiaries.filter { $0.phoneNumber.contains(newValue) }
                }

                if newValue == bavm.myPhoneNumber {
                    bavm.whoseNumber = WhoseNumberLabel.my
                } else if newValue.isEmpty {
                    bavm.whoseNumber = WhoseNumberLabel.none
                } else {
                    bavm.whoseNumber = WhoseNumberLabel.other
                }

            })
            .onChange(of: bavm.whoseNumber, perform: { newValue in
                if newValue == .my {
                    disablePhoneNumberTextField = true
                } else {
                    disablePhoneNumberTextField = false
                }
            })
            .sheet(isPresented: $contactViewModel.showContact) {
                showContactView(contactViewModel: contactViewModel)
            }
            .toolbar {
                handleKeyboardDone()
            }
            .handleViewStatesMods(uiState: bavm.$uiModel) { content in
                log(message: content)
            }
        }
        .backgroundmode(color: .white)
        .navigationBarBackButton(navigation: navigation)
        .onDisappear {
            bavm.uiModel = UIModel.nothing
        }
    }

    fileprivate func setServiceName(_ name: String) {
        bavm.slm.selectedProvider = name
    }

    fileprivate func setCurrentService(_ service: MerchantService) {
        bavm.currentService = service
    }

    fileprivate func setBeneficiariesFromEnrollments(_ enrollments: [Enrollment]) {
        bavm.oldBeneficiaries = enrollments.map {
            PreviousBeneficiaryModel(name: $0.accountAlias, phoneNumber: $0.accountNumber)
        }
    }

    fileprivate func setServiceModelFromServices(_ services: [MerchantService]) {
        bavm.slm.serviceModels = services.map {
            ServiceModel(name: $0.serviceName, logoUrl: $0.serviceLogo)
        }
    }

    fileprivate func setAmountHistory(_ phoneNumber: String) {
        let amount = bavm.history.filter {
            $0.accountNumber == phoneNumber && $0.serviceName == bavm.slm.selectedProvider
        }.map { $0.amount }
        let uniqueAmount = Set(amount).sorted(by: <)
        bavm.amountHistory = uniqueAmount
    }

    fileprivate func filterServiceBySelectedServiceName(from services: [MerchantService], name: String) -> MerchantService? {
        let service = services.first { serv in
            serv.serviceName == name
        }
        return service
    }

    fileprivate func handleKeyboardDone() -> ToolbarItemGroup<TupleView<(Spacer, Button<Text>?, Button<Text>?)>> {
        return ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            if focused == bavm.currentPhoneNumber {
                Button("Next") {
                    focused = bavm.selectedAmount
                }
            }
            if focused == bavm.selectedAmount {
                Button("Done") {
                    focused = nil
                }
            }
        }
    }

    private func fetchContacts() {
        Task {
            await contactViewModel.fetchPhoneContacts { err in
                bavm.uiModel = UIModel.error(err.localizedDescription)
            }
        }
    }

    private func getNetworkItems(_ airtimeServices: [ServiceModel]) -> [NetworkItem] {
        return airtimeServices.map { service in
            NetworkItem(
                imageUrl: service.logoUrl,
                networkName: service.name,
                selectedNetwork: service.name
            )
        }
    }

    public func onSubmitDefaultService(selected: String) {
        let service = filterServiceBySelectedServiceName(from: bavm.getAirtimeServices(), name: selected)
        if let service = service {
            bavm.defaultService = service
            let request = RequestMap.Builder()
                .add(value: service.hubServiceID.convertStringToInt(), for: "DEFAULT_NETWORK_SERVICE_ID")
                .add(value: "UPN", for: .SERVICE)
                .build()
            bavm.updateDefaultNetworkId(request: request)
        }
    }

    public func onDismiss() {
        showNetworkList = false
    }

    fileprivate func onButtonClick() {
        if bavm.slm.selectedProvider == "Unknown" {
            bavm.uiModel = UIModel.error("You have not selected a service")
            return
        }
        if !isValidPhoneNumber {
            bavm.uiModel = UIModel.error("Invalid phone number")
            return
        }
        if !isValidAmount {
            let min = bavm.currentService.minAmount
            let max = bavm.currentService.maxAmount
            bavm.uiModel = UIModel.error("Amount must be between \(min) and \(max)")
            return
        }
        checkoutVm.currentAccountNumber = bavm.currentPhoneNumber
        checkoutVm.enrollments = bavm.enrollments
        checkoutVm.currentService = bavm.currentService
        checkoutVm.selectedAmount = bavm.selectedAmount
        checkoutVm.showView = true
    }
}

struct WhoseNumberOptionView: View {
    @Binding var selected: WhoseNumberLabel
    var options: [WhoseNumberLabel] {
        WhoseNumberLabel.allCases.filter { opt in
            opt != WhoseNumberLabel.none
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options, id: \.self) { option in
                HRadioButtonAndText(selected: $selected.label, name: option.label)
                    .scaleEffect(0.9)
                Spacer()
            }
        }
    }
}

enum WhoseNumberLabel: String, CaseIterable {
    case my
    case other
    case none
    var label: String {
        get {
            rawValue.capitalized + " " + "number"
        }
        set {
            let v = newValue.lowercased().split(separator: " ")[0]
            self = WhoseNumberLabel(rawValue: String(v)) ?? .my
        }
    }
}

struct BuyAirtimeView_Previews: PreviewProvider {
    struct BuyAirtimePreviewHolder: View {
        @State var number = "200"
        var body: some View {
            BuyAirtimeView(selectedServiceName: "Airtel")
        }
    }

    static var previews: some View {
        BuyAirtimePreviewHolder()
            .environmentObject(ContactViewModel())
            .environmentObject(CheckoutDI.createCheckoutViewModel())
    }
}
