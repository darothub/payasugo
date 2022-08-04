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
    public var countryApiServices: TinggApiServices
    public var subscription = Set<AnyCancellable>()
    @Published public var countriesInfo = [Country]()
    public var countryRepository: CountryRepository
    public init(countryServices: TinggApiServices) {
        self.countryApiServices = countryServices
        self.countryRepository = CountryRepository(apiService: BaseRepository(), realmManager: RealmManager())
        countriesCodesAndCountriesDialCodes()
    }
    public convenience init(countryRepository: CountryRepository, countryServices: TinggApiServices){
        self.init(countryServices: countryServices)
        self.countryRepository = countryRepository
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
    @available(*, renamed: "getCountriesAndDialCode()")
    public func countriesCodesAndCountriesDialCodes() {
        Future<[Country], Never> { promise in
            self.getCountries { [unowned self] results in
                do {
                    let countriesInfo = try results.get().data
                    countryRepository.realmManager.save(data: countriesInfo)
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
        var countryDictionary =  [String: String]()
        let dBCountries = await countryRepository.realmManager.countries
        if dBCountries.isEmpty {
            let countries = try await countryRepository.getRemoteCountries().data
            await countryRepository.realmManager.save(data: countries)
            countryDictionary = countries.reduce(into: [:]) { partialResult, country in
                partialResult[country.countryCode!] = country.countryDialCode
            }
            return countryDictionary
        }
        return dBCountries.reduce(into: [:]) { partialResult, country in
            partialResult[country.countryCode!] = country.countryDialCode
        }
    }
    
    public func getCountryByDialCode(dialCode: String) async -> Country? {
        guard let country = await countryRepository.realmManager.filterCountryByDialCode(dialCode: dialCode) else {
            return nil
        }
        return country
    }
}
