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

public struct BuyAirtimeView: View {
    @EnvironmentObject var hvm: HomeViewModel
    @EnvironmentObject var bavm: BuyAirtimeViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @State private var selectedButton: String = ""
    @State private var defaultNetwork: [MerchantService] = [MerchantService]()
    @State private var showContact = false
    @State private var listOfContact = Set<ContactRow>()
    @State private var phoneNumber: String = ""
    @State private var accountNumber = ""
    @State private var amount = ""
    @State private var whoseNumber = WhoseNumberLabel.other
    @State private var showNetworkList = false
    @State private var show = false
    @State private var enrollments : [Enrollment] = sampleNominations
    @State private var providerDetails: [ProviderDetails] = .init()
    @State private var history: [TransactionHistory] = sampleTransactions
    @State private var airtimeServices:  [MerchantService] = sampleServices
    @State private var historyByAccountNumber: [String] = .init()
    @State private var currency = ""
    @State private var selectedService: MerchantService = .init()
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false
    @State private var fem: FavouriteEnrollmentModel = .init()
    @State private var sam: SuggestedAmountModel = .init()
    @State private var plm: ProvidersListModel = .init()
    @State private var sdm: ServicesDialogModel = .init()
    public init() {
        //
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            FavouriteListView(fem: $fem)
            Text("Mobile number")
                .padding(.top)
            TextFieldAndRightIcon(
                number: $contactViewModel.selectedContact 
            ) {
                Task {
                    await contactViewModel.fetchPhoneContacts { err in
                        hvm.uiModel = UIModel.error(err.localizedDescription)
                    }
                }
            }
            MerchantServiceListView(
                plm: $plm
            ) {
                fem.accountNumber = ""
            }.showIf(.constant(!plm.details.isEmpty))
            WhoseNumberOptionView(selected: $whoseNumber)
                .padding(.vertical)
            Text("Amount")
                .padding(.top)
            AmountAndCurrencyTextField(
                amount: $sam.amount,
                currency: $sam.currency
            )
            SuggestedAmountListView(
                accountNumberHistory: $sam.historyByAccountNumber,
                amountSelected: $sam.amount
            ).padding(.top)
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Buy airtime"
            ) {
                let isValidated = validatePhoneNumberByCountry(AppStorageManager.getCountry(), phoneNumber: fem.accountNumber)
                log(message: "Phone number \(fem.accountNumber) isvalidate \(isValidated)")
                if !isValidated {
                    hvm.showAlert = true
                    hvm.uiModel = UIModel.error("Invalid phone number")
                    return
                }
                let response = validateAmountByService(selectedService: selectedService, amount: sam.amount)
                if !response.isEmpty {
                    hvm.showAlert = true
                    hvm.uiModel = UIModel.error(response)
                    return
                }
                checkoutVm.fem = fem
                checkoutVm.sam = sam
                checkoutVm.plm = plm
                checkoutVm.enrollment = fem.enrollment
                checkoutVm.service = selectedService
                checkoutVm.amount = sam.amount
                checkoutVm.showView = true
            }
        }
        .padding()
        .onAppear {
            //Get user profile
            if let profile = hvm.getProfile(), let msisdn = profile.msisdn {
                phoneNumber = msisdn
                accountNumber = msisdn
            }
            //Show network dialog if default network is not set
            showNetworkList = AppStorageManager.getDefaultNetworkId().isEmpty
            
            //If default network is set
            if !showNetworkList {
                if let defaultNetwork = AppStorageManager.getDefaultNetwork() {
                    fem.enrollments = filterNomination(by: defaultNetwork)
                    plm.selectedProvider = defaultNetwork.serviceName
                    fem.selectedNetwork = defaultNetwork.serviceName
                    fem.accountNumber = phoneNumber
                }
            }
            //Set dialog data
            sdm.phoneNumber = phoneNumber
            sdm.airtimeServices = hvm.getAirtimeServices()
            
            //Set currency
            sam.currency = AppStorageManager.getCountry()?.currency ?? ""
            //Get and set nomination
            enrollments = hvm.nominationInfo.getEntities()
            //Get and set transaction history
            history = hvm.transactionHistory.getEntities()
           
            //Extract and set network providers
            plm.details = sdm.airtimeServices.map {
                ProviderDetails(service: $0)
            }
        }
        .customDialog(isPresented: $showNetworkList) {
            DialogContentView(sdm: $sdm, dismiss: $showNetworkList, onDismiss:  {
                showNetworkList.toggle()
            })
            .padding(20)
            .environmentObject(hvm)
            .environmentObject(bavm)
        }
        .onChange(of: sdm, perform: { newValue in
            let service = newValue.airtimeServices.first {
                $0.serviceName == sdm.selectedButton
            }
            fem.enrollments = filterNomination(by: service ?? .init())
            plm.selectedProvider = newValue.selectedButton
            fem.selectedNetwork = newValue.selectedButton
            fem.accountNumber = newValue.phoneNumber
        })
        .onChange(of: fem, perform: { newValue in
            if phoneNumber == newValue.enrollment.accountNumber {
                whoseNumber = WhoseNumberLabel.my
            } else {
                whoseNumber = WhoseNumberLabel.other
            }
            let amount = history.filter {
                ($0.accountNumber == newValue.accountNumber && $0.serviceName == newValue.selectedNetwork)
            }.map {$0.amount}
            let uniqueAmount = Set(amount).sorted(by: <)
            sam.historyByAccountNumber = uniqueAmount
            contactViewModel.selectedContact = newValue.enrollment.accountNumber
            
        })
        .onChange(of: plm, perform: { newValue in
            let service = hvm.getAirtimeServices().first {
                $0.serviceName == newValue.selectedProvider
            }
            if let s = service {
                let provider = newValue.details.first {
                    $0.service.serviceName == s.serviceName
                }
                fem.enrollments = filterNomination(by: provider?.service ?? .init())
                fem.selectedNetwork = newValue.selectedProvider
                selectedService = s
            }
         
        })
        .sheet(isPresented: $contactViewModel.showContact) {
            showContactView(contactViewModel: contactViewModel)
        }
        .handleViewStates(uiModel: $hvm.uiModel, showAlert: $hvm.showAlert)
    }
    
    private func handleContactFetch() async {
       await hvm.fetchPhoneContacts {
            listOfContact.insert(handleContacts(contacts: $0))
        }
    }
    
    private func onSelectDefaultNetwork() {
        showNetworkList = false
    }
}

struct DialogContentView: View {
    @EnvironmentObject var bavm: BuyAirtimeViewModel
    @EnvironmentObject var hvm: HomeViewModel
    @Binding var sdm: ServicesDialogModel
    @Binding var dismiss: Bool
    @State var showAlert = false
    var onSubmit: () -> Void = {}
    var onDismiss: () -> Void = {}
 
    var body: some View {
        VStack {
            Text("Select mobile network")
            Group {
                Text("Please select the mobile network that")
                + Text(" \(sdm.phoneNumber)").foregroundColor(.green)
                + Text(" belongs to")
            }.multilineTextAlignment(.center)
                .font(.caption)
            Divider()
            ForEach(sdm.airtimeServices, id: \.serviceName) { service in
                NetworkSelectionRowView(
                    imageUrl: service.serviceLogo,
                    networkName: service.serviceName,
                    selectedButton: $sdm.selectedButton
                ).showIf(.constant(!service.serviceName.isEmpty))
            }
            Text("No network available")
                .showIf(.constant(sdm.airtimeServices.isEmpty))
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Done"
            ) {
                if sdm.airtimeServices.isEmpty {
                    onDismiss()
                } else {
                    let service = hvm.getAirtimeServices().first { serv in
                        serv.serviceName == sdm.selectedButton
                    }
                    var request = TinggRequest()
                    if let s = service {
                        request.defaultNetworkServiceId = s.hubServiceID
                        request.service = "UPN"
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
        dismiss = false
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
            .environmentObject(AirtimeDI.createAirtimeViewModel())
            .environmentObject(ContactViewModel())
            .environmentObject(HomeDI.createHomeViewModel())
    }
}

