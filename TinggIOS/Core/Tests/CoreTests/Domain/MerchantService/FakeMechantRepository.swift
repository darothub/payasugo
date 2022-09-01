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
        realm.invalidate()
        saveDataInDB()
    }
    func saveDataInDB() {
        let data =        [
            MerchantService(),
            MerchantService(),
            MerchantService(),
            MerchantService(),
            MerchantService(),
            MerchantService(),
            MerchantService(),
            MerchantService(),
            MerchantService(),

           ]
        realm.save(data: data)
    }
    
    func getServices() -> [MerchantService] {
        dbObserver.getEntities()

    }
}
