//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Combine
import Foundation
import RealmSwift
import Core
public class FetchCountries: ObservableObject {
    let countryApiServices: TinggApiServices
    @Published public var phoneFieldDetails = [String: String]()
    public var subscription = Set<AnyCancellable>()
    @Published public var countriesInfo = [Country]()
    @ObservedResults(Country.self) public var countriesDb
    private(set) var realmManager = RealmManager()
    public init(countryServices: TinggApiServices) {
        self.countryApiServices = countryServices
        countriesCodesAndCountriesDialCodes()
    }
    func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        countryApiServices.getCountries()
            .responseDecodable(of: CountryDTO.self) {response in
                switch response.result {
                case .failure:
                    onCompletion(.failure(.networkError))
                case .success(let countries):
                    onCompletion(.success(countries))
                }
            }
    }
    public func countriesCodesAndCountriesDialCodes() {
        Future<[Country], Never> { promise in
            self.getCountries { [self] results in
                do {
                    let countriesInfo = try results.get().data
                    realmManager.save(data: countriesInfo)
                    promise(.success(countriesInfo))
                } catch {
                    print("FetcCountriesError \(error.localizedDescription)")
                }
            }
        }
        .assign(to: \.countriesInfo, on: self)
        .store(in: &subscription)
    }
}
