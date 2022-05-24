//
//  RestApi.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 04/02/2022.
//

import Foundation
import RxSwift

protocol RestApi {
  var mock: Data { get }
  func makeRequestFor(url: URL) -> Observable<Data>
}

extension RestApi{
  
  func makeRequestFor(url: URL) -> Observable<Data>{
    
    if let observer = checkEnvironment(){
      return observer
    }
    
    let req = URLRequest(url: url)
    return URLSession.shared.rx.response(request: req)
                               .flatMap{ response, data -> Observable<Data> in
                                 try processServer(response)
                                 guard let mime = response.mimeType, mime == "application/json"
                                 else {
                                   throw BaluchonError.badContentType
                                 }
                                   return Observable.just(data)
                               }
  }
  
  private func checkEnvironment() -> Observable<Data>?{
    
    if let local = ProcessInfo.processInfo.environment["Use_Local_Data"], local == "true" {
      return Observable.of(mock)
    }
    return nil
  }
  
  private func processServer(_ response: HTTPURLResponse) throws {
    switch response.statusCode {
    case 200...299: break
    case 404: throw BaluchonError.ressourceNotFound
    default: throw BaluchonError.badServerResponse
    }
  }
}
