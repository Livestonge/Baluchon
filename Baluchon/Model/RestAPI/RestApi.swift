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
  var session: URLSession { get }
  func makeRequestFor(url: URL) -> Observable<Data>
}

extension RestApi{
  
  func makeRequestFor(url: URL) -> Observable<Data>{
    
    if let observer = checkEnvironment(){
      return observer
    }
    
    return Observable<(HTTPURLResponse,Data)>.create{ observer in
      
      let task = session.dataTask(with: url){ data, response, error in
        guard let data = data, let response = response as? HTTPURLResponse else{
          observer.onError(error ?? BaluchonError.badServerResponse)
          return
        }
        
        observer.onNext((response, data))
        observer.onCompleted()
      }
      task.resume()
      return Disposables.create()
    }.flatMap{ response, data -> Observable<Data> in
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
