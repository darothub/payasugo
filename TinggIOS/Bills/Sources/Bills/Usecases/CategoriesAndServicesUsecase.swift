//
//  CategoriesAndServicesUsecase.swift
//  
//
//  Created by Abdulrasaq on 06/07/2023.
//
import Core
import Foundation
protocol CategoriesAndServicesUsecase {
    func callAsFunction() -> [String: [MerchantService]]
    func displayedRechargeAndBill() -> [MerchantService]
}
public class CategoriesAndServicesUsecaseImpl: CategoriesAndServicesUsecase {
    private var serviceRepository: MerchantServiceRepository
    private var categoryRepository: CategoryRepository
    public init(serviceRepository: MerchantServiceRepository, categoryRepository: CategoryRepository) {
        self.serviceRepository = serviceRepository
        self.categoryRepository = categoryRepository
    }
    
    /// A call as function method to group services by active categories
    /// - Returns: A dictionary of category and list of services
    public func callAsFunction() -> [String: [MerchantService]] {
        let services = serviceRepository.getServices()
        let categories = categoryRepository.getCategories()
        let idAndName = Dictionary(uniqueKeysWithValues: categories.map{($0.categoryID, $0.categoryName)})
        var dict = [String: [MerchantService]]()
        services.forEach { service in
            let contain = idAndName.contains { item in
                (item.key == service.categoryID) && (service.activeStatus == "1")
            }
            if contain, let name = idAndName[service.categoryID]  {
                var list:[MerchantService] = dict[name] ?? [MerchantService]()
                list.append(service)
                dict[name] = list
            }
        }
        return dict
    }
    
    public func displayedRechargeAndBill() -> [MerchantService] {
        let recharges = serviceRepository.getServices()
        if recharges.isNotEmpty() {
            return recharges.prefix(8).map {$0}
        }
        return []
    }
}
