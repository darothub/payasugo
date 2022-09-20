//
//  File.swift
//  
//
//  Created by Abdulrasaq on 30/08/2022.
//
import Core
import Foundation
import RealmSwift
class FakeMerchantRepository: MerchantServiceRepository {
    private var dbObserver: Observer<MerchantService>
    private let realm: RealmManager = .init()
    public init(dbObserver: Observer<MerchantService>) {
        //Public init
        self.dbObserver = dbObserver
        saveDataInDB()
    }
    func saveDataInDB() {
        let service1 = MerchantService()
        service1.serviceName = "Airtel"
        service1.hubServiceID = "1"
        service1.categoryID = "1"
        service1.presentmentType = "hasNone"
        let service2 = MerchantService()
        service2.serviceName = "DstvNg"
        service2.hubServiceID = "2"
        service2.categoryID = "2"
        service2.presentmentType = "hasPresentment"
        let service3 = MerchantService()
        service3.serviceName = "AON"
        service3.hubServiceID = "3"
        service3.categoryID = "3"
        service3.presentmentType = "hasPresentment"
        let data = [service1,service2,service3]
        realm.save(data: data)
    }
    
    func getServices() -> [MerchantService] {
        dbObserver.getEntities()
    }
}
