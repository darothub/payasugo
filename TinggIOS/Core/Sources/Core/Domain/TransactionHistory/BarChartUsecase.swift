//
//  File.swift
//  
//
//  Created by Abdulrasaq on 31/08/2022.
//

import Foundation
public class BarChartUsecase {
    private let transactHistoryRepository: TransactionHistoryRepository
    public init(transactHistoryRepository: TransactionHistoryRepository) {
        self.transactHistoryRepository = transactHistoryRepository
    }
    
    public func callAsFunction() -> [Int:Double] {
        var chartDataMap = [Int:Double]()
        let histories = transactHistoryRepository.getHistory()
        histories.forEach { history in
            guard let validDateString = history.paymentDate?.split(separator: ".").first else {
                fatalError("Invalid date format")
            }
            let date = makeDateFromString(validDateString: String(validDateString))
            let calendar = Calendar.current
            let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
            let monthIndex = components.month!
            let existingAmount = chartDataMap[monthIndex] ?? 0
           
            if let newAmount = Double( history.amount ?? "0.0" ){
                let amount = existingAmount + newAmount
                chartDataMap[monthIndex] = amount
            }
        }
        return chartDataMap
    }
}
