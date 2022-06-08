//
//  TransactionHistoryDao.swift
//  Core
//
//  Created by Abdulrasaq on 08/06/2022.
//

import Foundation
import RealmSwift

protocol TransactionHistoryDao {
    func getAllLive() ->  ObservedResults<TransactionHistory>
    func getByBeepIdLive(beepId: String?) ->  ObservedResults<TransactionHistory>
    func getFrequentTransactionsByAccountLive(
        accountNumber: String?,
        hubServiceId: String?
    ) -> Double
    func getAllByAccountLive(
        accountNumber: String?,
        hubServiceId: String?
    ) ->  ObservedResults<TransactionHistory>
    func getRecentSuccessTransactionsLive(
        startMonth: Int
    ) ->  ObservedResults<TransactionHistory>

    func getRecentSuccessTransactionsByAccountLive(
        startMonth: Int,
        accountNumber: String?,
        hubServiceId: String?
    ) ->  ObservedResults<TransactionHistory>
    func getWalletTransaction(type1: String, type2: String) ->  List<TransactionHistory>
    func getPendingTransactionsOlderThan30Minutes() ->  List<TransactionHistory>
    func findTransactionByBeepId(requestId: String?) ->  TransactionHistory?
}
