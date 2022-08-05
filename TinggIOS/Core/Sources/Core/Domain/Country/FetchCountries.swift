//
//  File.swift
//  
//
//  Created by Abdulrasaq on 01/07/2022.
//

import Combine
import Foundation
import RealmSwift
public class FetchCountries: ObservableObject {
    public var subscription = Set<AnyCancellable>()
    @ObservedResults(Country.self) var countries
    @Published public var countriesInfo = [Country]()
    public var countryRepository: CountryRepository
    public init(countryRepository: CountryRepository) {
        self.countryRepository = countryRepository
        countriesCodesAndCountriesDialCodes()
    }
    func getCountries(onCompletion: @escaping(Result<CountryDTO, ApiError>) -> Void) {
        self.countryRepository.apiService.getCountries()
            .responseDecodable(of: CountryDTO.self) {response in
                switch response.result {
                case .failure:
                    onCompletion(.failure(.networkError))
                case .success(let countries):
                    onCompletion(.success(countries))
                }
            }
    }
    @available(*, renamed: "getCountriesAndDialCode()")
    public func countriesCodesAndCountriesDialCodes() {
        Future<[Country], Never> { promise in
            self.getCountries { results in
                do {
                    let countriesInfo = try results.get().data
//                    countryRepository.realmManager.save(data: countriesInfo)
                    promise(.success(countriesInfo))
                } catch {
                    print("FetcCountriesError \(error.localizedDescription)")
                }
            }
        }
        .assign(to: \.countriesInfo, on: self)
        .store(in: &subscription)
    }
    public func getCountriesAndDialCode() async throws -> [String: String] {
        let countries = try await getCountries()
        print("Countries \(countries)")
        let countryDictionary = countries.reduce(into: [:]) { partialResult, country in
            partialResult[country.countryCode!] = country.countryDialCode
        }
        return countryDictionary
    }
    func getCountries() async throws -> [Country] {
        let localDb = try await Realm()
        if countries.isEmpty {
            let remoteData = try await countryRepository.getRemoteCountries().data
            localDb.writeAsync {
                localDb.add(remoteData, update: .modified)
            }
            return remoteData
        }
        return countries.reversed()
    }
}
