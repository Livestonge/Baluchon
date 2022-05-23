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
                                 let badResponse = processServer(response)
                                 guard badResponse == nil else {
                                   return Observable.error(badResponse!)
                                 }
                                 guard let mime = response.mimeType, mime == "application/json"
                                 else {
                                   return Observable.error(BaluchonError.badContentType)
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
  
  private func processServer(_ response: HTTPURLResponse) -> BaluchonError?{
    guard (200...299).contains(response.statusCode) == false else {return nil}
    
    if response.statusCode == 404 {
      return BaluchonError.ressourceNotFound
    }
    return BaluchonError.badServerResponse
  }
}
