//
//  SmileBiometricKYC.swift
//  
//
//  Created by Abdulrasaq on 23/03/2023.
//

import Foundation
import Smile_Identity_SDK
class SmileBiometricKYC: SIDNetworkRequestDelegate {
    func onStartJobStatus() {
        //
    }
    
    func onEndJobStatus() {
        //
    }
    
    func onUpdateJobProgress(progress: Int) {
        //
    }
    
    func onUpdateJobStatus(msg: String) {
        //
    }
    
    func onAuthenticated(sidResponse: Smile_Identity_SDK.SIDResponse) {
        //
    }
    
    func onEnrolled(sidResponse: Smile_Identity_SDK.SIDResponse) {
        //
    }
    
    func onComplete() {
        //
    }
    
    func onError(sidError: Smile_Identity_SDK.SIDError) {
        //
    }
    
    func onIdValidated(idValidationResponse: Smile_Identity_SDK.IDValidationResponse) {
        //
    }
    
    func onDocumentVerified(sidResponse: Smile_Identity_SDK.SIDResponse) {
        //
    }
    
    public static let callBackUrl = "https://customer-onboarding-service.dev.tingg.africa/customer/kyc/identity-verification"
    public func configureSmileJobEnrollment(kycDetails: KYCDetails) {
        var jobType = 1
        var userIdInfo = SIDUserIdInfo()
        
        if ((kycDetails.countryCode.elementsEqual("ZM")) != nil) {
            userIdInfo.setIdNumber(idNumber: "")
            jobType = 6
        }
        userIdInfo.setCountry(country : (kycDetails.countryCode))
        userIdInfo.setFirstName(firstName: kycDetails.firstName);
        userIdInfo.setLastName(lastName: kycDetails.lastName);
        userIdInfo.setIdNumber(idNumber: kycDetails.idNumber);
        userIdInfo.setIdType(idType : kycDetails.idType);
    }

    public func smileConfig(sidUserIdInfo: SIDUserIdInfo, jobType: Int, jobTag: String) {
        let sidNetData = SIDNetData(environment: SIDNetData.Environment.TEST)

        let sidNetworkRequest = SIDNetworkRequest()
        sidNetworkRequest.setDelegate(delegate: self)

        sidNetworkRequest.initialize()

        let sidConfig = SIDConfig()
        sidConfig.setSidNetData(sidNetData: sidNetData)
        sidConfig.setUserIdInfo(userIdInfo: sidUserIdInfo)
        sidConfig.setSidNetworkRequest( sidNetworkRequest : sidNetworkRequest )

        sidConfig.build(userTag: jobTag)

        do {
            try sidConfig.getSidNetworkRequest().submit(sidConfig: sidConfig )
        } catch {
            print("SmileIdentity " + error.localizedDescription)
        }
    }
}
