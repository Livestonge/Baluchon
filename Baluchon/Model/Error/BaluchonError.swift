//
//  CustomError.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 25/01/2022.
//

import Foundation

enum BaluchonError: String, Error{
  case BadConnexion
  case ressourceNotFound
  case badServerResponse
  case badContentType
  case badUrl
  case decodingError
  case providedOnlyDigits
  case unknown
  
  init(_ error: Error){
    switch error{
    case let error as BaluchonError:
      self = error
    case let error as URLError where error.errorCode == URLError.notConnectedToInternet.rawValue:
      self = .BadConnexion
    case let error as URLError where error.errorCode == URLError.Code.badURL.rawValue:
      self = .badUrl
    default: self = .unknown
    }
  }
  
  var description: String{
    switch self{
    case .BadConnexion:
      return "Please check your internet connexion and retry!!"
    case .badServerResponse,.badContentType, .badUrl:
      return "The connection to the server failed, please retry later"
    case .providedOnlyDigits:
      return "Please provide a text in the correct format"
    case .ressourceNotFound, .decodingError:
      return "Sorry, we can not find the requested ressource!!!"
    default: return "Something went wrong!!!"
    }
  }
}
