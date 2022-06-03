//
//  FixerAPI.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 24/01/2022.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

protocol CurrencyServiceProvider{
  func getCurrencyExchange() -> Observable<CurrencyExchange>
}

class FixerServiceProviding: RestApi, CurrencyServiceProvider {
  
  var mock = jsonData!
  var session: URLSession
  private var fileStorage: URL
  
  init(session: URLSession = .shared, storage: URL = .currencyStorage){
    self.session = session
    self.fileStorage = storage 
  }
  
  private var dateFormatter: DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter
  }
  
  lazy private var decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()
  
  lazy var components: URLComponents = {
    let todayCalenderString: String = dateFormatter.string(from: Date() - 2)
    var components = URLComponents()
    components.scheme = "http"
    components.host = "data.fixer.io"
    components.path = "/api/\(todayCalenderString)"
    
    components.queryItems = [
      URLQueryItem(name: "access_key", value: fixer_Conversion_Api_Key),
      URLQueryItem(name: "base", value: "EUR"),
      URLQueryItem(name: "symbols", value: Currency.USD.rawValue)
    ]
    return components
  }()
  
  
  func getCurrencyExchange() -> Observable<CurrencyExchange>{
    
    if let currencyExhange = getStoredCurrencyExchange(){
      return Observable.just(currencyExhange)
    }
    let url = self.components.url!
    
    return makeRequestFor(url: url)
                  .subscribe(on: MainScheduler.instance)
                  .decode(type: FixerCurrencyExchange.self, decoder: decoder)
                  .map{ $0.mapToCurrencyExchange() }
                  .do(onNext: { [weak self] value in
                    self?.saveCurrent(userCurrencyExchange: value)
                  })
                       
  }
  
  private func saveCurrent(userCurrencyExchange: CurrencyExchange){
    
    let currencyStorage = CurrencyStorage(date: Date(), currencyExchange: userCurrencyExchange)
    
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .formatted(dateFormatter)
    guard let data = try? encoder.encode(currencyStorage) else {
      return}
    try! data.write(to: self.fileStorage)
  }
  
  private func getStoredCurrencyExchanges() -> CurrencyStorage?{
    guard let data = try? Data(contentsOf: self.fileStorage) else {return nil}
    
    return try? self.decoder.decode(CurrencyStorage.self, from: data)
  }
  
  func getStoredCurrencyExchange() -> CurrencyExchange? {
    guard let storedCurrencyExchange = getStoredCurrencyExchanges() else {return nil}
    let dataHasExpired = storedCurrencyExchange.hasExpired
    return dataHasExpired ? nil : storedCurrencyExchange.currencyExchange
  }
  
}
