//
//  GoogleAPI.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 07/02/2022.
//

import Foundation
import RxSwift

protocol TranslateServiceProvider {
  func translate(text: String, from: Language, to: Language) -> Observable<TranslatedResponse>
}
class GoogleTranslateServiceProviding: RestApi, TranslateServiceProvider {
  
  var mock = googleTranslatedData!
  
  var components: URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "translation.googleapis.com"
    components.path = "/language/translate/v2"
    components.queryItems = [
      URLQueryItem(name: "key", value: google_Translate_Api_Key),
      URLQueryItem(name: "format", value: "text"),
      URLQueryItem(name: "model", value: "base")
    ]
    return components
  }
  
  func getUrlWith(text: String, target: Language, source: Language) -> URL {
    var components = self.components
    components.queryItems?.append(URLQueryItem(name: "q", value: text))
    components.queryItems?.append(URLQueryItem(name: "target", value: target.rawValue))
    components.queryItems?.append(URLQueryItem(name: "source", value: source.rawValue))
    return components.url!
  }
  
  func translate(text: String, from: Language, to: Language) -> Observable<TranslatedResponse>{
    let url = getUrlWith(text: text, target: to, source: from)
    return makeRequestFor(url: url)
                         .decode(type: GoogleTranslatedResponse.self, decoder: JSONDecoder())
                         .map{ TranslatedResponse(text: $0.translatedText) }
  }
}
