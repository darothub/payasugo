//
//  GetDueBillUsecase.swift
//  
//
//  Created by Abdulrasaq on 06/07/2023.
//
import Core
import Foundation

protocol GetDueBillUsecase {
    func getBillAccounts() -> [BillAccount]
    func getDueBills<T: BaseDTOprotocol>(request: RequestMap) async throws -> T
    func getSavedBill() -> [DueBillItem]
}

public struct BillAccount: Codable {
    public let serviceId: String
    public let accountNumber: String
    public init(serviceId: String, accountNumber: String){
        self.serviceId = serviceId
        self.accountNumber = accountNumber
    }
    enum CodingKeys: String, CodingKey {
        case serviceId = "SERVICE_ID"
        case accountNumber = "ACCOUNT_NUMBER"
    }
}

class GetDueBillUsecaseImpl : GetDueBillUsecase {
    let merchantServiceRepository: MerchantServiceRepository
    let enrollmentRepository : EnrollmentRepository
    let invoiceRepository: InvoiceRepository
    init(
        merchantServiceRepository: MerchantServiceRepository,
        enrollmentRepository : EnrollmentRepository,
        invoiceRepository: InvoiceRepository
    ) {
        self.merchantServiceRepository = merchantServiceRepository
        self.enrollmentRepository = enrollmentRepository
        self.invoiceRepository = invoiceRepository
    }
    func getBillAccounts() -> [BillAccount] {
        let services = merchantServiceRepository.getServices()
        let nominations = enrollmentRepository.getNominationInfo()

        let billAccounts = nominations.compactMap { nomination in
           let service = services.first { service in
               String(nomination.hubServiceID) == service.hubServiceID && (PresentmentType(rawValue: service.presentmentType) == PresentmentType.hasPresentment) && nomination.isExplicit
            }
            if let service = service {
                return BillAccount(serviceId:String(service.hubServiceID), accountNumber: String(nomination.accountNumber))
            }
            return nil
        }
        
        return billAccounts
    }
    
    func getDueBills<T: BaseDTOprotocol>(request: Core.RequestMap) async throws -> T {
        let fetchedBillDTO: FetchBillDTO = try await invoiceRepository.fetchDueBills(tinggRequest: request)
        let fetchedBill = fetchedBillDTO.fetchedBills
        let invoices = fetchedBill.map { $0.convertToInvoice() }
        invoices.forEach { invoiceRepository.insertInvoiceInDb(invoice: $0)}
        return fetchedBillDTO as! T
    }

    func getSavedBill() -> [DueBillItem] {
        let invoices = invoiceRepository.getInvoices()
        let services = merchantServiceRepository.getServices()
        let billAccounts = getBillAccounts()
        let filteredServicesAndEnrollment = billAccounts.compactMap { ba in
            let invoice = invoices.first { i in
                i.billReference == ba.accountNumber
            }
            let service = services.first { s in
                ba.serviceId == s.hubServiceID
            }
            return (s: service, i: invoice)
        }

        let savedBillItems = filteredServicesAndEnrollment.compactMap { (s, i) in
            if let service = s, let bill = i {
                return DueBillItem(
                    serviceName: service.serviceName,
                    serviceImageString: service.serviceLogo,
                    beneficiaryName: bill.customerName,
                    accountNumber: bill.billReference,
                    amount: "",
                    dueDate: ""
                )
            } else {
                return nil
            }
        }
        Log.d(message: "Saved Bill \(savedBillItems)")
        return savedBillItems
    }
}
