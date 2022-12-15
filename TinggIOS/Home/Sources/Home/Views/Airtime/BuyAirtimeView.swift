//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 27/09/2022.
//
import Common
import Core
import Contacts
import Permissions
import SwiftUI
import Theme

public struct BuyAirtimeView: View {
    @StateObject var hvm: HomeViewModel = HomeDI.createHomeViewModel()
    @StateObject var bavm = BuyAirtimeViewModel()
    @State var selectedButton: String = ""
    @State var defaultNetwork: [MerchantService] = [MerchantService]()
    @State var showContact = false
    @State var listOfContact = Set<ContactRow>()
    @State var phoneNumber: String = ""
    @State var accountNumber = ""
    @State var amount = ""
    @State var whoseNumber = WhoseNumberLabel.other
    @State var showNetworkList = false
    @EnvironmentObject var showCheckout: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @State var show = false
    @State var enrollments : [Enrollment] = sampleNominations
    @State var providerDetails: [ProviderDetails] = .init()
    @State var history: [TransactionHistory] = sampleTransactions
    @State var airtimeServices:  [MerchantService] = sampleServices
    @State var historyByAccountNumber: [String] = .init()
    @State var currency = ""
    public init() {
        //
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            FavouriteListView(flvm: $bavm.favouriteEnrollmentListModel)
            Text("Mobile number")
                .padding(.top)
            TextFieldAndRightIcon(
                number: $bavm.favouriteEnrollmentListModel.accountNumber
            ) {
                Task {
                    await contactViewModel.fetchPhoneContacts { err in
                        hvm.uiModel = UIModel.error(err.localizedDescription)
                    }
                }
            }
            ProvidersListView(
                plm: $bavm.providersListModel
            ) {
                bavm.favouriteEnrollmentListModel.accountNumber = ""
            }
            WhoseNumberOptionView(selected: $whoseNumber)
                .padding(.vertical)
            Text("Amount")
                .padding(.top)
            TextFieldAndLeftIcon(amount: $bavm.suggestedAmountModel.amount, currency: currency)
            SuggestedAmountListView(
                sam: $bavm.suggestedAmountModel
            ).padding(.top)
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Buy airtime"
            ) {
//                remotePhoneNumberValidation(hvm.country)
                let selectedService = airtimeServices.first {$0.serviceName == selectedButton}
                if let service = selectedService {
//                    remoteAmountValidation(selectedService: service)
                    showCheckout.showCheckOutView = true
                    showCheckout.service = service
                }
            }
        }
        .padding()
        .onAppear {
            phoneNumber = hvm.profile.msisdn!
            accountNumber = phoneNumber
            bavm.servicesDialogModel.phoneNumber = phoneNumber
            bavm.servicesDialogModel.airtimeServices = hvm.airTimeServices
            let defaultNetwork = hvm.airTimeServices.first { $0.hubServiceID == hvm.defaultNetworkServiceId }
            showNetworkList = defaultNetwork == nil
//            selectedButton = defaultNetwork?.serviceName ?? ""
            hvm.observeUIModel(model: hvm.$defaultNetworkUIModel) { content in
                showNetworkList = false
            }
            currency = AppStorageManager.getCountry()?.currency ?? ""
            enrollments = hvm.nominationInfo.getEntities()
            history = hvm.transactionHistory.getEntities()
            airtimeServices = hvm.airTimeServices
            bavm.providersListModel.details = airtimeServices.map {
                ProviderDetails(service: $0)
            }
        }
        .customDialog(isPresented: $showNetworkList) {
            DialogContentView() {
                hvm.updateDefaultNetworkId(serviceName: bavm.servicesDialogModel.selectedButton)
            }
            .padding(20)
            .environmentObject(hvm)
            .environmentObject(bavm)
            .handleViewStates(uiModel: $hvm.defaultNetworkUIModel, showAlert: $hvm.showAlert)
        }
        .onChange(of: bavm.servicesDialogModel, perform: { newValue in
            let service = newValue.airtimeServices.first {
                $0.serviceName == bavm.servicesDialogModel.selectedButton
            }
            let nomination =  hvm.nominationInfo.getEntities().filter { e in
                service?.hubServiceID == String(e.hubServiceID)
            }
            bavm.favouriteEnrollmentListModel.enrollments = nomination.map {$0}
            bavm.providersListModel.selectedProvider = newValue.selectedButton
            bavm.favouriteEnrollmentListModel.selectedNetwork = newValue.selectedButton
            bavm.favouriteEnrollmentListModel.accountNumber = newValue.phoneNumber
        })
        .onChange(of: bavm.favouriteEnrollmentListModel, perform: { newValue in
            if phoneNumber == newValue.accountNumber {
                whoseNumber = WhoseNumberLabel.my
            } else {
                whoseNumber = WhoseNumberLabel.other
            }
            let amount = history.filter {
                ($0.accountNumber == newValue.accountNumber && $0.serviceName == newValue.selectedNetwork)
            }.map {$0.amount}
            let uniqueAmount = Set(amount).sorted(by: <)
            bavm.suggestedAmountModel.historyByAccountNumber = uniqueAmount
        })
        .onChange(of: bavm.providersListModel, perform: { newValue in
            let provider = newValue.details.first {
                $0.service.serviceName == newValue.selectedProvider
            }
            let nomination =  hvm.nominationInfo.getEntities().filter { e in
                provider?.service.hubServiceID == String(e.hubServiceID)
            }
            bavm.favouriteEnrollmentListModel.enrollments = nomination.map {$0}
            bavm.favouriteEnrollmentListModel.selectedNetwork = newValue.selectedProvider
        })
        .handleViewStates(uiModel: $hvm.uiModel, showAlert: $hvm.showAlert)
    }
    
    func handleContactFetch() async {
       await hvm.fetchPhoneContacts {
            listOfContact.insert(handleContacts(contacts: $0))
        }
    }
    
    fileprivate func remotePhoneNumberValidation(_ country: Country?) {
        if let regex = country?.countryMobileRegex {
            let result = validatePhoneNumber(with: regex, phoneNumber: accountNumber)
            if !result {
                hvm.showAlert = true
                hvm.uiModel = UIModel.error("Invalid phone number")
            }
        }
    }
    
    fileprivate func remoteAmountValidation(selectedService: MerchantService) {
        let intAmount = convertStringToInt(value: amount)
        let minAmount = convertStringToInt(value: selectedService.minAmount)
        let maxAmount = convertStringToInt(value: selectedService.maxAmount)
        if amount.isEmpty {
            hvm.showAlert = true
            hvm.uiModel = UIModel.error("Amount field can not be empty")
        }
        else if intAmount < minAmount || intAmount > maxAmount {
            hvm.showAlert = true
            hvm.uiModel = UIModel.error("Amount should between \(minAmount) and \(maxAmount)")
        }
    }
}

struct DialogContentView: View {
//    var phoneNumber: String = "080"
//    var airtimeServices = [MerchantService]()
//    @Binding var selectedButton: String
    @EnvironmentObject var bavm: BuyAirtimeViewModel
//    @EnvironmentObject var hvm: HomeViewModel
    var onSubmit: () -> Void = {}
    var body: some View {
        VStack {
            Text("Select mobile network")
            Group {
                Text("Please select the mobile network that")
                + Text(" \(bavm.servicesDialogModel.phoneNumber)").foregroundColor(.green)
                + Text(" belongs to")
            }.multilineTextAlignment(.center)
                .font(.caption)
            Divider()
            ForEach(bavm.servicesDialogModel.airtimeServices, id: \.serviceName) { service in
                NetworkSelectionRowView(
                    imageUrl: service.serviceLogo,
                    networkName: service.serviceName,
                    selectedButton: $bavm.servicesDialogModel.selectedButton
                )
            }
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Done"
            ) {
                onSubmit()
            }
        }
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

struct TextFieldAndRightIcon: View {
    @Binding var number: String
    var onImageClick: () -> Void
    var body: some View {
        HStack {
            TextField("Mobile number", text: $number)
                .keyboardType(.phonePad)
            Image(systemName: "person")
                .onTapGesture {
                    onImageClick()
                }
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
        ).foregroundColor(.black)
    }
}
struct TextFieldAndLeftIcon: View {
    @Binding var amount: String
    var currency: String = ""
    var body: some View {
        HStack {
            Text(currency)
                .bold()
            TextField("Enter amount", text: $amount)
                .keyboardType(.numberPad)
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
        ).foregroundColor(.black)
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
                HRadioButtonAndText(selected: .constant(selected.label), name: option.label)
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
        self.rawValue.capitalized + " " + "number"
    }
}

struct HRadioButtonAndText: View {
    @Binding var selected: String
    @State var name = ""
    var body: some View {
        HStack{
            RadioButtonView(selected: $selected, id: name)
            Text(name)
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
            .environmentObject(CheckoutViewModel())
            .environmentObject(ContactViewModel())
    }
}
