//
//  DaoProtocol.swift
//  Core
//
//  Created by Abdulrasaq on 07/06/2022.
//
// swiftlint:disable all
import Foundation
import RealmSwift

protocol ProfileDao {
    associatedtype Model
    func getActive(anchor: String) -> Model?
    func updateWalletStatus(status: String) -> Int
    func updateProfile(status: String, walletId: String, walletAccount: String) -> Int
    func updateProfileName(firstName: String, lastName: String)-> Int
    func updateProfileInfo(nationalId: String, jsonArrayToString: String?)
}
//extension DaoProtocol {
//    var getAll: Self  { Model.self as! Self }
//}

//extension Profile : ProfileDao {
//    typealias Model = Profile
//    func getActive(anchor: String) -> Profile? {
//        let active = realm?.objects(Profile.self).where {
//            $0.isMain == anchor
//        }.first
//        return active
//    }
//
//}
