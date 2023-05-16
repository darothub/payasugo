//
//  BuyAirtimeView.swift
//  
//
//  Created by Abdulrasaq on 27/09/2022.
//
import Checkout
import CoreUI
import Core
import Contacts
import Permissions
import SwiftUI
import Theme
import RealmSwift

public struct BuyAirtimeView: View, OnNetweorkSelectionListener {
    @Environment(\.realmManager) var realmManager
    @StateObject var bavm: BuyAirtimeViewModel = AirtimeDI.createBuyAirtimeVM()
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State public var fem: FavouriteEnrollmentModel = .init()
    @State public var slm: ServicesListModel = .init()
    @State public var sam: SuggestedAmountModel = .init()
    @State private var listOfContact = Set<ContactRow>()
    @State private var whoseNumber = WhoseNumberLabel.other
    @State private var enrollments : [Enrollment] = sampleNominations
    @State private var history: [TransactionHistory] = sampleTransactions
    @State private var showErrorAlert = false
    @State private var showNetworkList = false
    @State var keyboardYOffset: CGFloat = 10
    @State private var networkList: [NetworkItem] = []
    @State private var defaultService: MerchantService = .init()
    @State private var defaultServiceName = ""
    @State private var phoneNumber: String = ""
    @FocusState var focused: String?
    public init() {
        //
    }
    
    public var body: some View {
        VStack(alignment: .leading)  {
            FavouriteListView(fem: $fem)
            Text("Mobile number")
                .padding(.top)
            TextFieldAndRightIcon(
                number: $fem.accountNumber
            ) {
                fetchContacts()
            }.focused($focused, equals: contactViewModel.selectedContact)
            
            ServicesListView(slm: $slm, onChangeSelection: {
                fem.accountNumber = ""
            }).showIfNot(.constant(slm.services.isEmpty))
            WhoseNumberOptionView(selected: $whoseNumber)
                .padding(.vertical)
            TextFieldView(fieldText: $sam.amount, label: "Amount", placeHolder: "Enter amount", type: .numberPad)
                .focused($focused, equals: sam.amount)
            
            SuggestedAmountListView(
                accountNumberHistory: $sam.historyByAccountNumber,
                amountSelected: $sam.amount
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
        .onAppear {
            //Get user profile
            if let profile = Observer<Profile>().getEntities().first, let msisdn = profile.msisdn {
                ServicesListModel.phoneNumber = msisdn
//                accountNumber = msisdn
            }
            let networkServiceId = AppStorageManager.getDefaultNetworkId()
            //Show network dialog if default network is not set
            showNetworkList = networkServiceId == nil || networkServiceId  == 0
            //If default network is set
            if !showNetworkList, let defaultNetwork = AppStorageManager.getDefaultNetwork() {
                let enrollment = updateEnrollment(defaultNetwork: defaultNetwork)
                fem.enrollments = enrollment
                slm.selectedService = defaultNetwork
                slm.selectedProvider = defaultNetwork.serviceName
                fem.selectedNetwork = defaultNetwork.serviceName
                fem.accountNumber = ServicesListModel.phoneNumber
            }
            //Set services for services list
            slm.services = bavm.getAirtimeServices()
            
            //Set currency
            sam.currency = AppStorageManager.getCountry()?.currency ?? ""
            
            //Get and set transaction history
            history = Observer<TransactionHistory>().getEntities()
            
            phoneNumber = AppStorageManager.getPhoneNumber()
            defaultService = AppStorageManager.getDefaultNetwork() ?? .init()
            defaultServiceName = defaultService.serviceName
            showNetworks()
        }
        .customDialog(isPresented: $showNetworkList) {
            DialogContentView(networkList: networkList, phoneNumber: phoneNumber, selectedNetwork: defaultServiceName, listner: self)
                .padding()
                .handleViewStatesMods(uiState: bavm.$defaultNetworkUIModel) { content in
                    log(message: content)
                } action: {
                    showNetworkList = false
                }
        }
        .onChange(of: contactViewModel.selectedContact, perform: { newValue in
            fem.accountNumber = newValue
        })
        .onChange(of: fem, perform: { newValue in
            if ServicesListModel.phoneNumber == newValue.accountNumber {
                whoseNumber = WhoseNumberLabel.my
            } else if newValue.accountNumber.isEmpty {
                whoseNumber = WhoseNumberLabel.none
            } else {
                whoseNumber = WhoseNumberLabel.other
            }
            let amount = history.filter {
                ($0.accountNumber == newValue.accountNumber && $0.serviceName == newValue.selectedNetwork)
            }.map {$0.amount}
            let uniqueAmount = Set(amount).sorted(by: <)
            sam.historyByAccountNumber = uniqueAmount
            
        })
        .onChange(of: slm, perform: { newValue in
            let service = slm.services.first {
                $0.serviceName == newValue.selectedProvider
            }
            if let s = service {
                let enrollment = updateEnrollment(defaultNetwork: s)
                fem.enrollments = enrollment
                fem.selectedNetwork = newValue.selectedProvider
                slm.selectedService = s
            }
            contactViewModel.selectedContact = ""
        })
        .onChange(of: sam.amount) { newValue in
            sam.amount = newValue.applyPattern(pattern: "\(sam.currency) ##")
        }
        .sheet(isPresented: $contactViewModel.showContact) {
            showContactView(contactViewModel: contactViewModel)
        }
        .handleViewStatesMods(uiState: bavm.$uiModel) { content in
            log(message: content)
        }
        .toolbar {
            handleKeyboardDone()
        }
        
    }
    fileprivate func handleKeyboardDone() -> ToolbarItemGroup<TupleView<(Spacer, Button<Text>?, Button<Text>?)>> {
        return ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            if focused == contactViewModel.selectedContact {
                Button("Next") {
                    focused = sam.amount
                }
            }
            if focused == sam.amount {
                Button("Done") {
                    focused = nil
                }
            }
        }
    }
 
    private func fetchContacts() {
        Task {
            await contactViewModel.fetchPhoneContacts { err in
                showErrorAlert = true
                bavm.uiModel = UIModel.error(err.localizedDescription)
            }
        }
    }
    private func showNetworks() {
        let airtimeServices = Observer<MerchantService>().getEntities().filter { $0.isAirtimeService }
        networkList = airtimeServices.map { service in
            NetworkItem(
                imageUrl: service.serviceLogo,
                networkName: service.serviceName,
                selectedNetwork: service.serviceName
            )

        }
    }
    public func onSubmit(selected: String) {
        let service = Observer<MerchantService>().getEntities().first { serv in
            serv.serviceName == selected
        }
        if let s = service {
            defaultService = s
            let request = RequestMap.Builder()
                .add(value: s.hubServiceID.convertStringToInt(), for: "DEFAULT_NETWORK_SERVICE_ID")
                .add(value: "UPN", for: .SERVICE)
                .build()
            bavm.updateDefaultNetworkId(request: request)
        }
    }
    
    public func onDismiss() {
        showNetworkList = false
    }
    fileprivate func updateEnrollment(defaultNetwork: MerchantService) -> [Enrollment] {
        let nomination = filterNomination(by: defaultNetwork)
        return nomination.map({ e in
            if (e.accountNumber == ServicesListModel.phoneNumber) && (e.accountAlias.isEmpty) {
                realmManager.realmWrite {
                    e.accountAlias = "Me"
                }
            }
            return e
        })
    }
    fileprivate func onButtonClick() {
        if slm.selectedService.serviceName == "Unknown" {
            showErrorAlert = true
            bavm.uiModel = UIModel.error("You have not selected a service")
            return
        }
        let isValidated = validatePhoneNumberByCountry(AppStorageManager.getCountry(), phoneNumber: fem.accountNumber)
        if !isValidated {
            showErrorAlert = true
            bavm.uiModel = UIModel.error("Invalid phone number")
            return
        }
        
        let currency = sam.currency
        let amount = sam.amount.replace(string: currency, replacement: "").removeWhitespace()
        let response = validateAmountByService(selectedService: slm.selectedService, amount: amount)
        if !response.isEmpty {
            showErrorAlert = true
            bavm.uiModel = UIModel.error(response)
            return
        }
        checkoutVm.fem = fem
        checkoutVm.sam = sam
        checkoutVm.slm = slm
        checkoutVm.enrollment = fem.enrollment
        checkoutVm.service = slm.selectedService
        checkoutVm.amount = sam.amount
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
            self.rawValue.capitalized + " " + "number"
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
            BuyAirtimeView()
        }
    }
    static var previews: some View {
        BuyAirtimePreviewHolder()
            .environmentObject(ContactViewModel())
    }
}

