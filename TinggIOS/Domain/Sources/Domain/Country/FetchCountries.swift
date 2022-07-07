//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//
import ApiModule
import Combine
import Foundation
import RealmSwift
public class FetchCountries: ObservableObject {
    let countryApiServices: CountryApiServices
    @Published public var phoneFieldDetails = [String: String]()
    public var subscription = Set<AnyCancellable>()
    @Published public var countriesInfo = [Country]()
    @ObservedResults(Country.self) public var countriesDb

    public init() {
        self.countryApiServices = CountryRepository()
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
                    DispatchQueue.main.async {
                        for country in countriesInfo {
                            self.$countriesDb.append(country)
                        }
                    }
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
