//
//  PostMCPUsecaseTest.swift
//  
//
//  Created by Abdulrasaq on 14/09/2022.
//
import Core
import XCTest

final class PostMCPUsecaseTest: XCTestCase {
    private var enrolmentRepository: EnrollmentRepository!
    private var invoiceRepository: InvoiceRepository!
    private var usecase: PostMCPUsecase!

    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        enrolmentRepository = FakeEnrollmentRepository(dbObserver: Observer<Enrollment>())
        invoiceRepository = FetchBillRepositoryImpl(baseRequest: FakeBaseRequest(), dbObserver: Observer<Invoice>())
        usecase = PostMCPUsecase(repository: enrolmentRepository, invoiceRepository: invoiceRepository)
    }
    
    func testSavedBillWasConvertedToEnrollmentAndSavedInTheDB() {
        let bill = Bill()
        bill.clientProfileAccountID = "1245678"
        let invoice = Invoice()
        invoice.billReference  = "1245678"
        _ = usecase(bill: bill, invoice: invoice)
        
        let nomination = enrolmentRepository.getNominationInfo().first { enrollment in
            String(enrollment.clientProfileAccountID) == bill.clientProfileAccountID
        }
        XCTAssertNotNil(nomination)
        let actual =  bill.clientProfileAccountID
        guard let nom = nomination else {
            fatalError("Nomination is invalid")
        }
        let expected = String(nom.clientProfileAccountID)
        XCTAssertEqual(actual, expected, "Expected \(expected) but found \(String(describing: actual))")
    }
    
    func testInvoiceIsSavedInTheDB() {
        let bill = Bill()
        bill.clientProfileAccountID = "1245678"
        let mockInvoice = Invoice()
        mockInvoice.billReference  = "1245678"
        _ = usecase(bill: bill, invoice: mockInvoice)
        let dbInvoices = Observer<Invoice>().getEntities()
        let dbInvoice = dbInvoices.first { invoice in
            invoice.billReference == mockInvoice.billReference
        }
        XCTAssertNotNil(dbInvoice)
    }

}
