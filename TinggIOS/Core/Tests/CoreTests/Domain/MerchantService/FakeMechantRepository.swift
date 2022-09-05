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
    var services = Observer<MerchantService>().objects

    var dbObserver: Observer<MerchantService>
    let realm: RealmManager = .init()
    public init(dbObserver: Observer<MerchantService>) {
        //Public init
        self.dbObserver = dbObserver
        saveDataInDB()
    }
    func saveDataInDB() {
        let service1 = MerchantService()
        service1.serviceName = "Airtel"
        let service2 = MerchantService()
        service2.serviceName = "DstvNg"
        let service3 = MerchantService()
        service3.serviceName = "AON"
        let data = [service3, service1, service2, ]
        realm.save(data: data)
    }
    
    func getServices() -> [MerchantService] {
        dbObserver.getEntities()
    }
}
