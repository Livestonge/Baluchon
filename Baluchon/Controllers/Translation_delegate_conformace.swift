//
//  Translation_delegate_conformace.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 26/05/2022.
//

import Foundation

extension MainTranslationControllerViewController: TranslationSourceDelegate{
  
  func getUserTranslation(_ translation: (String, String)) {
    presentTranslatedVC(with: translation.0, sourceText: translation.1)
  }
  
  private func presentTranslatedVC(with translatedText: String, sourceText: String){
    guard let vc = storyboard?.instantiateViewController(withIdentifier: "translatedVC") as? TranslatedViewController else { return }
    vc.translatedText = translatedText
    vc.sourceText = sourceText
    if let _ = navigationController?.topViewController as? TranslatedViewController { return }
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func didFailWith(_ error: BaluchonError) {
    subscribeToMainThread { [weak self] in
      self?.presentAlertFor(error)
    }
  }
  
  private func presentAlertFor(_ error: BaluchonError){
    let alertVC = BaluchonAlert(error: error).controller
    present(alertVC, animated: true)
  }
  
}
