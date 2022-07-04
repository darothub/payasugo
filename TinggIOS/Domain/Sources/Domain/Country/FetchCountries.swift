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
//    @ObservedResults(Person.self) var countries
    public init() {
        self.countryApiServices = CountryRepository()
        countriesCodesAndCountriesDialCodes()
    }
    func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        countryApiServices.getCountries()
            .responseDecodable(of: CountryDTO.self) {response in
                switch response.result {
                case .failure(_):
                    onCompletion(.failure(.networkError))
                case .success(let countries):
                    onCompletion(.success(countries))
                }
            }
    }
    public func countriesCodesAndCountriesDialCodes() {
        Future<[String: String], Never> { promise in
            self.getCountries { results in
                do {
                    let countriesInfo = try results.get().data
//                    print("CountriesInfo \(countriesInfo)")
                    let dict = countriesInfo
                        .reduce(into: [:]) { partialResult, country in
                            partialResult[country.countryCode! as String] = country.countryDialCode! as String
                        }
                    print("FetcCountriesSucces \(dict)")
                    promise(.success(dict))
                } catch {
                    print("FetcCountriesError \(error.localizedDescription)")
                }
            }
        }
        .assign(to: \.phoneFieldDetails, on: self)
        .store(in: &subscription)
    }
}
