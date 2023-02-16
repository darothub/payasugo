//
//  SwiftUIView.swift
//  
//
//  Created by Abdulrasaq on 07/12/2022.
//
import Theme
import SwiftUI
import Common
import Core
import Contacts
import Permissions


public struct CheckoutView: View {
    @EnvironmentObject var checkoutVm: CheckoutViewModel
    @EnvironmentObject var contactViewModel: ContactViewModel
    @EnvironmentObject var navigation: NavigationUtils
    @Environment(\.dismiss) var dismiss
    @State var selectedButton: String = "Diamond Trust Bank"
    @State var accountNumber = ""
    @State var title: String = "Buy Airtime"
    @State var amount: String = "Amount"
    @State var amountTextFieldPlaceHolder = "Enter amount"
    @State var selectPaymentTitle = "Select payment method"
    @State var someoneElseIsPaying = false
    @State var history: [TransactionHistory] = sampleTransactions
    @State var providerDetails: [ProviderDetails] = .init()
    @State var networkId = "1"
    @State var historyByAccountNumber: [String] = .init()
    @State var showCardPinView = false
    @State var pin: String = ""
    @State var confirmPin: String = ""
    @State var createdPin = false
    @State var pinIsCreated: Bool = false
    @State var showSecurityQuestionView = false
    @State var questions:[String] = .init()
    @State var selectedQuestion:String = ""
    @State private var showingDropDown = false
    @State var selectedAccount:String = ""
    @State var accountList = [String]()
    @State var isQuickTopUpOrAirtime = false
    public init () {
        //
    }
    public var body: some View {
        VStack(alignment: .center) {
            Section {
                HStack {
                    Text(title)
                        .frame(alignment: .center)
                        .padding(.vertical)
                        .bold()
                    Spacer()
                    IconImageCardView(
                        imageUrl: checkoutVm.service.serviceLogo,
                        radius: 50,
                        scaleEffect: 0.7
                    )
                }
                DropDownView(selectedText: $selectedAccount, dropDownList: $accountList, showDropDown: $showingDropDown
                ).showIf($isQuickTopUpOrAirtime)
                Group {
                    AmountAndCurrencyTextField(
                        amount: $checkoutVm.suggestedAmountModel.amount,
                        currency: $checkoutVm.suggestedAmountModel.currency
                    ).disabled(checkoutVm.service.canEditAmount == "0" ? true : false)
                    
                    SuggestedAmountListView(
                        accountNumberHistory: $checkoutVm.suggestedAmountModel.historyByAccountNumber,
                        amountSelected: $checkoutVm.suggestedAmountModel.amount
                    ).padding(.top)
                    MerchantPayerListView(
                        plm: $checkoutVm.providersListModel
                    ) {
                        checkoutVm.favouriteEnrollmentListModel.accountNumber = ""
                    }
                }.showIfNot($showingDropDown)
            
            }.padding(.horizontal)
            Section {
                Toggle("Ask someone else to pay", isOn:  $someoneElseIsPaying)
                    .toggleStyle(SwitchToggleStyle(tint: PrimaryTheme.getColor(.primaryColor)))
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 0.5)
                           
                    )
                TextFieldAndRightIcon(
                    number: $checkoutVm.favouriteEnrollmentListModel.accountNumber
                ) {
                    Task {
                        await contactViewModel.fetchPhoneContacts { err in
                            checkoutVm.uiModel = UIModel.error(err.localizedDescription)
                        }
                    }
                }.disabled(checkoutVm.isSomeoneElsePaying ? false : true)
                .showIf($someoneElseIsPaying)
            }.padding(.horizontal)
            .showIf($checkoutVm.isSomeoneElsePaying)
            .showIfNot($showingDropDown)
            Group {
                DebitCardDropDownView(dcddm: $checkoutVm.dcddm)
                    .padding()
                    .showIf($checkoutVm.showCardOptions)
                    .showIf(.constant(checkoutVm.dcddm.cardDetails.isNotEmpty()))
                AddNewDebitOrCreditCardButton() {
                    dismiss()
                    checkoutVm.cardDetails.amount = checkoutVm.suggestedAmountModel.amount
                    navigation.navigationStack.append(.pinCreationView)
                }
                .showIf($checkoutVm.addNewCard)
                .padding(30)
            }.showIfNot($showingDropDown)
            
            Spacer()
            button(
                backgroundColor: PrimaryTheme.getColor(.primaryColor),
                buttonLabel: "Buy airtime"
            ) {
                let isValidated: Bool = validatePhoneNumberByCountry(AppStorageManager.getCountry(), phoneNumber: checkoutVm.favouriteEnrollmentListModel.accountNumber)
                if !isValidated {
                    checkoutVm.showAlert = true
                    checkoutVm.uiModel = UIModel.error("Invalid phone number")
                }
                let response = validateAmountByService(selectedService: checkoutVm.service, amount: checkoutVm.suggestedAmountModel.amount)
                if !response.isEmpty {
                    checkoutVm.showAlert = true
                    checkoutVm.uiModel = UIModel.error(response)
                }
            }
        }
        .sheet(isPresented: $contactViewModel.showContact) {
            showContactView(contactViewModel: contactViewModel)
        }
        .onAppear {
            checkoutVm.providersListModel.details = Observer<MerchantPayer>().getEntities()
                .filter{$0.activeStatus != "0"}.map {
                    ProviderDetails(payer: $0, othersCanPay: $0.canPayForOther  != "0" ? true : false)
            }
            questions = Observer<SecurityQuestion>().getEntities().map {$0.question}
            checkoutVm.cardDetails.amount = checkoutVm.suggestedAmountModel.amount
            accountList = checkoutVm.favouriteEnrollmentListModel.enrollments.compactMap {$0.accountNumber}
            isQuickTopUpOrAirtime = checkoutVm.service.isAirtimeService
            log(message: "\(checkoutVm.service)")
        }
        .onChange(of: checkoutVm.providersListModel) { model in
            someoneElseIsPaying = false
            checkoutVm.isSomeoneElsePaying = model.canOthersPay
           
            if model.selectedProvider == "Card" {
                let selectedDetails = model.details.first {$0.payer.clientName == model.selectedProvider}
                let listOfCards = getListOfCards(imageUrl: selectedDetails?.payer.logo ?? "")
                if listOfCards.isNotEmpty() {
                    checkoutVm.dcddm.selectedCardDetails = listOfCards[0]
                    checkoutVm.dcddm.cardDetails = listOfCards
                    checkoutVm.showCardOptions = true
                }
                checkoutVm.addNewCard = true
              
            } else {
                checkoutVm.showCardOptions = false
                checkoutVm.addNewCard = false
            }
        }
        .onChange(of: contactViewModel.selectedContact) { newValue in
            checkoutVm.favouriteEnrollmentListModel.accountNumber = newValue
        }
        .handleViewStates(uiModel: $checkoutVm.uiModel, showAlert: .constant(true))
    }
    func getListOfCards(imageUrl:String) -> [CardDetailDTO] {
        return Observer<Card>().getEntities().map { c in
             CardDetailDTO(cardAlias: c.cardAlias ?? "", payerClientID: c.payerClientID ?? "", cardType: c.cardType ?? "", activeStatus: c.activeStatus ?? "", logoUrl: imageUrl)
        }
    }
    func getAvailableInvoice() -> Invoice? {
       return Observer<Invoice>().getEntities().first(where: { invoice in
            checkoutVm.favouriteEnrollmentListModel.enrollments.first { e in
                e.clientProfileAccountID == invoice.enrollment?.clientProfileAccountID
            }?.accountNumber == checkoutVm.favouriteEnrollmentListModel.accountNumber
        })
    }
}

struct BuyAirtimeCheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
            .environmentObject(CheckoutDI.createCheckoutViewModel())
            .environmentObject(ContactViewModel())
            .environmentObject(NavigationUtils())
    }
}


