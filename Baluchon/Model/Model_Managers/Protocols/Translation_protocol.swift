//
//  Translation_protocol.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 26/05/2022.
//

import Foundation

protocol TranslationSourceDelegate: AnyObject, Failable{
  func getUserTranslation(_ translation: (String, String))
}
