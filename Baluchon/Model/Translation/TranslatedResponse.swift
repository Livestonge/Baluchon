//
//  TranslatedResponse.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 07/02/2022.
//

import Foundation

struct TranslatedResponse: Decodable, Equatable{
  let text: String
  
  enum CodingKeys: String, CodingKey{
    case text = "translatedText"
  }
}

extension TranslatedResponse{
  
  init(from decoder: Decoder) throws {
    do{
      let container = try decoder.singleValueContainer()
      let responseObject = try container.decode([String: [String: [[String: String]]]].self)
      let translatedObject = responseObject["data"]?["translations"]?.first
      self.text = translatedObject?["translatedText"] ?? ""
      return
    }catch{
      throw BaluchonError.decodingError
    }
  }
  
}
