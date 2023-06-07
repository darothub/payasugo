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
    @State private var whoseNumber = WhoseNumberLabel.none
    @State private var enrollments : [Enrollment] = sampleNominations
    @State private var history: [TransactionHistory] = sampleTransactions
    @State private var showErrorAlert = false
    @State private var showNetworkList = false
    @State var keyboardYOffset: CGFloat = 10
    @State private var networkList: [NetworkItem] = []
    @State private var defaultService: MerchantService = .init()
    @State private var defaultServiceName = ""
    @State private var phoneNumber: String = ""
    @State public var selectedServiceName: String = ""
    @State private var airtimeServices: [MerchantService] = .init()
    @State private var disablePhoneNumberTextField = false
    @State private var isAmountEmpty = false
    @FocusState var focused: String?
    public init(selectedServiceName: String) {
        self._selectedServiceName = State(initialValue: selectedServiceName)
    }
    
    public var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading)  {
                FavouriteListView(fem: $fem)
                Text("Mobile number")
                    .font(.subheadline)
                    .padding(.top)
                    .foregroundColor(.black)
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
                Group {
                    Text("Amount")
                        .font(.subheadline)
                        .padding(.top)
                        .foregroundColor(.black)
                    TextFieldAndLeftTitle(number: $sam.amount, iconName: $sam.currency, placeHolder: "Enter amount", keyboardType: .numberPad, success: $isAmountEmpty)
                        .focused($focused, equals: sam.amount)
                }
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
            .background(.white)
            .onAppear {
                //Get user profile
                ServicesListModel.phoneNumber = AppStorageManager.getPhoneNumber()
                
                airtimeServices = Observer<MerchantService>().getEntities().filter { $0.isAirtimeService}
                
                updateServiceModel(services: airtimeServices)
                networkList = getNetworkItems(slm.services)
                
                let enrollments = getCorrespondingEnrollment(to: slm.selectedService)
                fem.enrollments = enrollments
                fem.selectedNetwork = slm.selectedService.serviceName
                guard let userDefaultNetwork = AppStorageManager.getDefaultNetwork() else {
                    //Show network dialog if default network is not set
                    showNetworkList = true
                    return
                }
               
                defaultService = userDefaultNetwork
                if selectedServiceName.elementsEqual(userDefaultNetwork.serviceName) {
                    //Set phone number if it is the default network or service
                    updateDefaultMyDetails()
                }
                
                //Set currency
                sam.currency = AppStorageManager.getCountry()?.currency ?? ""
                
                //Get and set transaction history
                history = Observer<TransactionHistory>().getEntities()
             
            }
            .customDialog(isPresented: $showNetworkList) {
                DialogContentView(networkList: networkList, phoneNumber: ServicesListModel.phoneNumber, selectedNetwork: defaultServiceName, listener: self)
                    .padding()
                    .handleViewStatesMods(uiState: bavm.$defaultNetworkUIModel) { content in
                        slm.selectedProvider = defaultService.serviceName
                        slm.selectedService = defaultService
                        AppStorageManager.setDefaultNetworkId(id: defaultService.hubServiceID.convertStringToInt())
                        AppStorageManager.setDefaultNetwork(service: defaultService)
                        let enrollments = getCorrespondingEnrollment(to: slm.selectedService)
                        fem.enrollments = enrollments
                        fem.selectedNetwork = slm.selectedService.serviceName
                        fem.accountNumber = ServicesListModel.phoneNumber
                    } action: {
                        showNetworkList = false
                    }
            }
            .onChange(of: contactViewModel.selectedContact, perform: { newValue in
                fem.accountNumber = newValue
            })
            .onChange(of: fem, perform: { newValue in
                if defaultService.serviceName == selectedServiceName {
                    whoseNumber = WhoseNumberLabel.my
                } else if newValue.accountNumber.isEmpty {
                    whoseNumber = WhoseNumberLabel.none
                } else {
                    whoseNumber = WhoseNumberLabel.other
                }
                do {
                    //Using the phone number without the dial code to confirm match
                    //1. get dialcode
                    let dialCode = AppStorageManager.getCountry()?.countryDialCode
                    //2. remove dialcode
                    let phoneNumber = ServicesListModel.phoneNumber.replace(string: dialCode ?? "", replacement: "")
                    //3. pass phone number without dialcode as regex
                    let phoneNumberRegex = try! Regex(phoneNumber)
                    //4. check match
                    let defaultPhoneNumberMatch = fem.accountNumber.firstMatch(of: phoneNumberRegex)
                    // 5. get result
                    let result = defaultPhoneNumberMatch?.output.last?.value
                    //6. check result
                    if result != nil {
                        slm.selectedService = defaultService
                        slm.selectedProvider = defaultService.serviceName
                    }
                } catch {
                    log(message: error)
                }
                let amount = history.filter {
                    ($0.accountNumber == newValue.accountNumber && $0.serviceName == newValue.selectedNetwork)
                }.map {$0.amount}
                let uniqueAmount = Set(amount).sorted(by: <)
                sam.historyByAccountNumber = uniqueAmount
                
            })
            .onChange(of: slm, perform: { newValue in
                guard let s = filterServiceBySelectedServiceName(from: newValue.services, name: newValue.selectedProvider) else {
                    return
                }
                if defaultService.serviceName.elementsEqual(s.serviceName) {
                    updateDefaultMyDetails()
                }
                let enrollment = getCorrespondingEnrollment(to: s)
                fem.enrollments = enrollment
                fem.selectedNetwork = newValue.selectedProvider
                slm.selectedService = s
                contactViewModel.selectedContact = ""
            })
            .onChange(of: sam.amount) { newValue in
                isAmountEmpty = !newValue.isEmpty
            }
            .onChange(of: whoseNumber, perform: { newValue in
                if whoseNumber == .my {
                    disablePhoneNumberTextField = true
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
        
    }
    
    fileprivate func updateDefaultMyDetails() {
        //Set phone number if it is the default network or service
        fem.accountNumber = ServicesListModel.phoneNumber
        disablePhoneNumberTextField = true
        whoseNumber = .my
    }
    fileprivate func filterServiceBySelectedServiceName(from services: [MerchantService], name: String) -> MerchantService? {
        let service = services.first { serv in
            serv.serviceName == name
        }
        return service
        
    }
    fileprivate func updateServiceModel(services: [MerchantService]) {
        
        if let selectedService =  filterServiceBySelectedServiceName(from: services, name: selectedServiceName) {
            //Set services for services list
            slm.services = services
            //Set selected service
            slm.selectedProvider = selectedServiceName
            
            slm.selectedService = selectedService
        }
    }
    fileprivate func handleKeyboardDone() -> ToolbarItemGroup<TupleView<(Spacer, Button<Text>?, Button<Text>?)>> {
        return ToolbarItemGroup(placement: .keyboard) {
            Spacer()
            if focused == fem.accountNumber {
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
    private func getNetworkItems(_ airtimeServices: [MerchantService]) -> [NetworkItem] {
        return airtimeServices.map { service in
            NetworkItem(
                imageUrl: service.serviceLogo,
                networkName: service.serviceName,
                selectedNetwork: service.serviceName
            )

        }
    }
    public func onServiceSubmission(selected: String) {
        let service = filterServiceBySelectedServiceName(from: slm.services, name: selected)
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
    fileprivate func getCorrespondingEnrollment(to service: MerchantService) -> [Enrollment] {
        let nomination = filterNomination(by: service)
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
            BuyAirtimeView(selectedServiceName: "Airtel")
        }
    }
    static var previews: some View {
        BuyAirtimePreviewHolder()
            .environmentObject(ContactViewModel())
    }
}

