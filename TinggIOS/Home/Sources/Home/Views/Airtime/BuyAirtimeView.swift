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
    @State var selectedButton: String = ""
    @StateObject var hvm = HomeDI.createHomeViewModel()
    @State var services: [MerchantService] = [MerchantService]()
    @State var defaultNetwork: [MerchantService] = [MerchantService]()
    @State var onPersonIconClicked = false
    @State var permission = ContactManager()
    @State var showContact = false
    @State var listOfContact = [ContactRow]()
    @State var strs = [String]()
    @State var contactImage: Image?
    var currency: String {
        if let currentCurrency = hvm.transactionHistory.first?.currencyCode {
            return currentCurrency
        }
        return ""
    }
    var enrollments : [Enrollment] {
        return hvm.nominationInfo.map {$0}
    }
    @State var phoneNumber: String = ""
    @State var accountNumber = ""
    @State var amount = ""
    var historyByAccountNumber: [TransactionHistory] {
        hvm.transactionHistory.map {$0}
    }
    public init() {
        //
    }
    public var body: some View {
        VStack(alignment: .leading) {
            FavouriteListView(
                enrollments: enrollments,
                airtimeServices: hvm.airTimeServices,
                accountNumber: $accountNumber,
                selectedNetwork: $selectedButton
            )
            Text("Mobile number")
                .padding(.top)
            TextFieldAndRightIcon(
                number: $accountNumber,
                onIconClick: $onPersonIconClicked
            ) {
            
                showContact.toggle()
                listOfContact.removeAll()
                Task {
                    await permission.fetchContacts { result in
                        switch result {
                        case .failure(let error):
                            print("Contact error \(error.localizedDescription)")
                        case .success(let contacts):
                            
                            let name = contacts.givenName + " " + contacts.familyName
                            var phoneNumber = ""
                            for number in contacts.phoneNumbers  {
                                print("Numbers \(number)")
                                switch number.label {
                                default:
                                    let mobile = number.value.stringValue
                                    phoneNumber = mobile
                                }
                            }
                            if let thumbnailData = contacts.imageData, let uiImage = UIImage(data: thumbnailData) {
                                contactImage = Image(uiImage: uiImage)
                                let contactRow = ContactRow(name: name, image: contactImage, phoneNumber: phoneNumber)
                                listOfContact.append(contactRow)
                                return
                            }
                            let contactRow = ContactRow(name: name, image: nil, phoneNumber: phoneNumber)
                            listOfContact.append(contactRow)
                            print("\(listOfContact)")
                        }
                    }
                }
            }
            AirtimeProviderListView(
                selectedProvider: $selectedButton,
                airtimeProviders: $hvm.airTimeServices,
                defaultNetworkId: $hvm.defaultNetworkServiceId
            ){
                resetAccountNumber()
            }
            Text("Amount")
                .padding(.top)
            TextFieldAndLeftIcon(amount: $amount, currency: currency)
            SuggestedAmountListView(history: historyByAccountNumber, amount: $amount, accountNumber: $accountNumber)
                .padding(.top)
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Buy airtime"
            ) {
                let country = AppStorageManager.getCountry()
                if let regex = country?.countryMobileRegex {
                   let result = validatePhoneNumber(with: regex, phoneNumber: accountNumber)
                    print("Valid \(result)")
                }
                if amount.isEmpty {
                    print("Amount is empty")
                }
            }
        }
        .padding()
        .onAppear {
            phoneNumber = hvm.profile.msisdn!
            hvm.$airTimeServices.sink { services in
                defaultNetwork = services.filter {
                    $0.hubServiceID == hvm.defaultNetworkServiceId
                }
                hvm.showNetworkList = defaultNetwork.isEmpty
            }.store(in: &hvm.subscriptions)
           
        }
        .customDialog(isPresented: $hvm.showNetworkList) {
            DialogContentView(
                phoneNumber: phoneNumber,
                airtimeServices: hvm.airTimeServices,
                selectedButton: $selectedButton
            )
            .padding(20)
            .environmentObject(hvm)
        }
        .sheet(isPresented: $showContact, content: {
            ContactRowView(listOfContactRow: listOfContact){contact in
                print("Selected \(contact)")
                accountNumber = contact.phoneNumber
                showContact.toggle()
            }
        })
        .handleViewStates(uiModel: $hvm.uiModel, showAlert: $hvm.showAlert)
    }
    
    func resetAccountNumber() {
        accountNumber = ""
    }
}

struct DialogContentView: View {
    var phoneNumber: String = "080"
    var airtimeServices = [MerchantService]()
    @Binding var selectedButton: String
    @EnvironmentObject var hvm: HomeViewModel
    var body: some View {
        VStack {
            Text("Select mobile network")
            Group {
                Text("Please select the mobile network that")
                + Text(" \(phoneNumber)").foregroundColor(.green)
                + Text(" belongs to")
            }.multilineTextAlignment(.center)
                .font(.caption)
            Divider()
            ForEach(airtimeServices, id: \.serviceName) { service in
                NetworkSelectionRowView(
                    imageUrl: service.serviceLogo,
                    networkName: service.serviceName,
                    selectedButton: $selectedButton
                )
            }
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Done"
            ) {
                hvm.updateDefaultNetworkId(serviceName: selectedButton)
            }.handleViewStates(uiModel: $hvm.defaultNetworkUIModel, showAlert: $hvm.showAlert)
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
                PrimaryTheme.getImage(image: .tinggIcon)
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
    @Binding var onIconClick: Bool
    var onImageClick: () -> Void
    var body: some View {
        HStack {
            TextField("Mobile number", text: $number)
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
        }.padding()
        .background(
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
        ).foregroundColor(.black)
    }
}
struct BuyAirtimeView_Previews: PreviewProvider {
    struct BuyAirtimePreviewHolder: View {
        @State var number = "200"
        var body: some View {
            BoxedTextView(text: $number)
        }
    }
    static var previews: some View {
        BuyAirtimePreviewHolder()
    }
}
