//
//  MainTranslationControllerViewController.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 04/02/2022.
//

import UIKit
import RxSwift

class MainTranslationControllerViewController: UIViewController {

  @IBOutlet weak var textViewMain: UITextView!
  @IBOutlet var buttonChooseLanguage: UIButton!
  private var resetTextButton: UIButton!
  
  var translationManager: TranslationManager!
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
      super.viewDidLoad()
    
    navigationItem.title = "Traduction"
    
    textViewMain.layer.cornerRadius = 20
    textViewMain.clipsToBounds = true
    resetTextButton = UIButton.resetButton
    resetTextButton.addTarget(self,
                     action: #selector(resetText),
                     for: .touchUpInside)
    textViewMain.addCloseButton(button: resetTextButton)
    textViewMain.becomeFirstResponder()
    textViewMain.delegate = self
    displayResetButton()
    
    buttonChooseLanguage.layer.cornerRadius = 10
    buttonChooseLanguage.clipsToBounds = true
    buttonChooseLanguage.backgroundColor = .yellow
    
    buttonChooseLanguage.addTarget(self, action: #selector(didTapChooseLanguageBt),
                                   for: .touchUpInside)
    translationManager.delegate = self
    
  }
  
  func displayResetButton(){
    resetTextButton.isHidden = !textViewMain.hasText
  }
  
  @objc
  func resetText(){
    self.textViewMain.text = ""
    displayResetButton()
  }
  
  private func presentLanguageOptions(){
    
    guard let textToTranslate = textViewMain.text, isInCorrectFormat(textToTranslate) else {
      self.translationManager.action = .didProvideWrongInput(.providedOnlyDigits)
      return }
    
    let alert = UIAlertController(title: "Choose a language",
                                  message: nil,
                                  preferredStyle: .actionSheet)
    
    let frenchOption = UIAlertAction(title: "Français",
                                     style: .default) { [weak self] _ in
      self?.translationManager.action = .didChooseLanguage(.fr, textToTranslate)
                                                      }
    
    let englishOption = UIAlertAction(title: "Anglais",
                                      style: .default){ [weak self] _ in
      self?.translationManager.action = .didChooseLanguage(.en, textToTranslate)
                                                      }
    alert.addAction(frenchOption)
    alert.addAction(englishOption)
    
    present(alert, animated: true)
  }
  
  @objc
  private func didTapChooseLanguageBt(){
    resetTextButton.isHidden = true
    textViewMain.resignFirstResponder()
    self.presentLanguageOptions()
  }
  
  private func isInCorrectFormat(_ text: String) -> Bool {
    
    if text.isEmpty == false && text.containsOnlyDigits == false {
      return true
    }
    return false
  }

}

extension String{
  
  var containsOnlyDigits: Bool{
    let digits = CharacterSet.decimalDigits
    return CharacterSet(charactersIn: self).isSubset(of: digits)
  }
}

extension MainTranslationControllerViewController: UITextViewDelegate{
  func textViewDidChange(_ textView: UITextView) {
    displayResetButton()
  }
}
