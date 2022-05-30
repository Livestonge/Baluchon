//
//  GoogleTranslatedResponse.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 24/05/2022.
//

import Foundation


struct GoogleTranslatedResponse: Decodable, Equatable{
  let translatedText: String
}

extension GoogleTranslatedResponse{
  
  init(from decoder: Decoder) throws {
    do{
      let container = try decoder.singleValueContainer()
      let responseObject = try container.decode([String: [String: [[String: String]]]].self)
      let translatedObject = responseObject["data"]?["translations"]?.first
      self.translatedText = translatedObject?["translatedText"] ?? ""
      return
    }catch{
      throw BaluchonError.decodingError
    }
  }
  
}
