//
//  BuyAirtimeView.swift
//  
//
//  Created by Abdulrasaq on 27/09/2022.
//
import Checkout
import Common
import Core
import Contacts
import Permissions
import SwiftUI
import Theme

public struct BuyAirtimeView: View, CheckoutProtocol {
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
                Task {
                    await contactViewModel.fetchPhoneContacts { err in
                        showErrorAlert = true
                        bavm.uiModel = UIModel.error(err.localizedDescription)
                    }
                }
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
            //Show network dialog if default network is not set
            showNetworkList = AppStorageManager.getDefaultNetworkId().isEmpty
            //If default network is set
            if !showNetworkList {
                if let defaultNetwork = AppStorageManager.getDefaultNetwork() {
                    fem.enrollments = filterNomination(by: defaultNetwork)
                    slm.selectedService = defaultNetwork
                    slm.selectedProvider = defaultNetwork.serviceName
                    fem.selectedNetwork = defaultNetwork.serviceName
                    fem.accountNumber = ServicesListModel.phoneNumber
                }
            }
            //Set services for services list
            slm.services = bavm.getAirtimeServices()
            
            //Set currency
            sam.currency = AppStorageManager.getCountry()?.currency ?? ""
            
            //Get and set transaction history
            history = Observer<TransactionHistory>().getEntities()
            
          
        }
        .customDialog(isPresented: $showNetworkList) {
            DialogContentView(slm: $slm, show: $showNetworkList, onDismiss:  {
                withAnimation {
                    showNetworkList.toggle()
                    fem.enrollments = filterNomination(by: slm.selectedService)
                    fem.selectedNetwork = slm.selectedProvider
                    fem.accountNumber = ServicesListModel.phoneNumber
                }
            })
            .padding(20)
            .environmentObject(bavm)
        }
        .onChange(of: contactViewModel.selectedContact, perform: { newValue in
            fem.accountNumber = newValue
        })
        .onChange(of: fem, perform: { newValue in
            if ServicesListModel.phoneNumber == newValue.enrollment.accountNumber {
                whoseNumber = WhoseNumberLabel.my
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
                fem.enrollments = filterNomination(by: s)
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
        .handleViewStates(uiModel: $bavm.uiModel, showAlert: $showErrorAlert)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
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

struct DialogContentView: View {
    @EnvironmentObject var bavm: BuyAirtimeViewModel
    @Binding var slm: ServicesListModel
    @Binding var show: Bool
    @State var showAlert = false
    var onSubmit: () -> Void = {}
    var onDismiss: () -> Void = {}
 
    var body: some View {
        VStack {
            Text("Select mobile network")
            Group {
                Text("Please select the mobile network that")
                + Text(" \(ServicesListModel.phoneNumber)").foregroundColor(.green)
                + Text(" belongs to")
            }.multilineTextAlignment(.center)
                .font(.caption)
            Divider()
            ForEach(slm.services, id: \.serviceName) { service in
                NetworkSelectionRowView(
                    imageUrl: service.serviceLogo,
                    networkName: service.serviceName,
                    selectedButton: $slm.selectedProvider
                ).showIfNot(.constant(service.serviceName.isEmpty))
            }
            Text("No network available")
                .showIf(.constant(slm.services.isEmpty))
            TinggButton(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Done"
            ) {
                if slm.services.isEmpty {
                    onDismiss()
                } else {
                    let service = slm.services.first { serv in
                        serv.serviceName == slm.selectedProvider
                    }
                    var request = TinggRequest()
                    if let s = service {
                        request.defaultNetworkServiceId = s.hubServiceID
                        request.service = "UPN"
                        slm.selectedService = s
                    }
                    bavm.updateDefaultNetworkId(request: request)
                    //Observe default network update request
                    bavm.observeUIModel(model: bavm.$defaultNetworkUIModel, subscriptions: &bavm.subscriptions) { content in
                        showAlert = true
                    } onError: { err in
                        showAlert = true
                    }
                }
              
            }
        }.handleViewStates(uiModel: $bavm.defaultNetworkUIModel, showAlert: $showAlert, showSuccessAlert: $showAlert, onSuccessAction:  onSelectDefaultNetwork)
    }
    
    func onSelectDefaultNetwork() {
        show = false
    }
    
}
struct NetworkSelectionRowView: View {
    @State var imageUrl: String = ""
    @State var networkName: String = "Airtel"
    @Binding var selectedButton:String
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageUrl)) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            } placeholder: {
                Image(systemName: "camera.fill")
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding()
            }
            Text(networkName)
            Spacer()
            RadioButtonView(selected: $selectedButton, id: networkName)
        }
    }
}
struct WhoseNumberOptionView: View {
    @Binding var selected: WhoseNumberLabel
    var options: [WhoseNumberLabel] {
        WhoseNumberLabel.allCases
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

