//
//  Mock_translation_restApi.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 03/06/2022.
//

import Foundation
import RxSwift
@testable import Baluchon

class MockGoogleRestApi: GoogleTranslateServiceProviding{
  
  override func translate(text: String, from: Language, to: Language) -> Observable<TranslatedResponse> {
    let translatedResponse = try? JSONDecoder().decode(GoogleTranslatedResponse.self, from: googleTranslatedData!)
    return .just(translatedResponse!.mapToTranslatedResponse())
  }
}
