//
//  ViewController.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 17/01/2022.
//

import UIKit
import RxSwift
import FlagKit
import RxRelay

class ViewController: UIViewController {

  @IBOutlet weak var mainStackView: UIStackView!
  
  @IBOutlet weak var converterView: UIView!
  @IBOutlet weak var convertedCurrencyLabel: UILabel!
  @IBOutlet weak var convertedValue: UILabel!
  @IBOutlet weak var converterCurrencyImageView: UIImageView!
	@IBOutlet weak var userInputView: UIView!
	@IBOutlet weak var userInputImageView: UIImageView!
  @IBOutlet weak var converterCurrencyLabel: UILabel!
  @IBOutlet weak var userCurrencyLabel: UILabel!
  @IBOutlet weak var userInputTextField: UITextField!
  @IBOutlet weak var switchView: SwitchView!
  @IBOutlet var tapGestureOnSwitchView: UITapGestureRecognizer!
  
  private var toggleCurrencies = false
  private var mainStackCenterYConstraint: NSLayoutConstraint!
  
  var currencyManager: CurrencyManager!
  let disposeBag = DisposeBag()
  
  override func loadView() {
    super.loadView()
    mainStackCenterYConstraint = mainStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
  }
  
  override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		converterView.layer.cornerRadius = 20
		userInputView.layer.cornerRadius = 20
    tapGestureOnSwitchView.addTarget(self,
                                     action: #selector(didTapOnSwitchView))
    
    converterCurrencyLabel.text = ""
    userInputTextField.delegate = self
		toggleDisplayOfCurrencies()
    userInputTextField.becomeFirstResponder()
    userInputTextField.keyboardType = .decimalPad
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(adjustMainStackViewForKeyboard),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(adjustMainStackViewForKeyboard),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
    
    currencyManager.delegate = self
    
    userInputTextField.rx
                      .controlEvent([.editingDidEndOnExit, .editingDidBegin])
                      .map{ self.userInputTextField.text ?? ""}
                      .filter{ $0.isEmpty == false }
                      .map{ Double($0) ?? 0.0}
                      .observe(on: MainScheduler.instance)
                      .subscribe(onNext: { [weak self] value in
                        self?.currencyManager.action = .hasTappedValue(value)
                      })
                      .disposed(by: disposeBag)
    
	}
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillShowNotification,
                                              object: nil)
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillHideNotification,
                                              object: nil)
  }

  @objc
  func adjustMainStackViewForKeyboard(_ notification: NSNotification){
    
    switch notification.name {
    case UIResponder.keyboardWillShowNotification:
      adjustView(constant: -80)
    case UIResponder.keyboardWillHideNotification:
      adjustView(constant: 0)
    default: break
    }
    
  }
  @objc
  func didTapOnSwitchView(_ tap: UITapGestureRecognizer){
    toggleCurrencies.toggle()
    toggleDisplayOfCurrencies()
    let value = Double(userInputTextField.text ?? "") ?? 0.0
    currencyManager.action = .didSwitchedCurrency(value)
    
  }
  
  private func toggleDisplayOfCurrencies(){
    
    guard let usFlag = Flag(countryCode: "US"),
            let euroFlag = Flag(countryCode: "EU") else {return}
    let usFlagImage: UIImage = usFlag.image(style: .circle)
    let euroFlagImage: UIImage = euroFlag.image(style: .circle)
    
    converterCurrencyImageView.image = toggleCurrencies == false ? usFlagImage : euroFlagImage
    converterCurrencyLabel.text = toggleCurrencies == false ? "USD" : "EUR"
    userInputImageView.image = toggleCurrencies == false ? euroFlagImage : usFlagImage
    userCurrencyLabel.text = toggleCurrencies == false ? "EUR" : "USD"
  }
  
  private func adjustView(constant: CGFloat){
    NSLayoutConstraint.deactivate([mainStackCenterYConstraint])
    mainStackCenterYConstraint = mainStackView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor, constant: constant)
    NSLayoutConstraint.activate([mainStackCenterYConstraint])
    
  }

}

extension ViewController: UITextFieldDelegate{
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    var text = textField.text ?? ""
    if string == "" {
      let characterRange = range.lowerBound
      let index = text.index(text.startIndex, offsetBy: characterRange)
      text.remove(at: index)
    }else{
      text += string
    }
    let value = Double(text) ?? 0.0
    self.currencyManager.action = .hasTappedValue(value)
    
    return true
  }
}
