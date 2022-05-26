//
//  WeatherViewController.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 15/02/2022.
//

import UIKit
import RxSwift
class WeatherViewController: UIViewController {

  @IBOutlet weak var textFieldCity: UITextField!
  @IBOutlet weak var labelHumidity: UILabel!
  @IBOutlet weak var labelTemperature: UILabel!
  @IBOutlet weak var labelIcon: UILabel!
  @IBOutlet weak var labelWeatherDescription: UILabel!
  @IBOutlet var gestureRecognizerSearchImage: UITapGestureRecognizer!
  let disposeBag = DisposeBag()
  
  var weatherManager: WeatherManager!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gestureRecognizerSearchImage.addTarget(self, action: #selector(didTapOnSearchButton))
    weatherManager.delegate = self
    
    textFieldCity.rx.controlEvent([.editingDidEndOnExit])
                 .map{ self.textFieldCity.text ?? ""}
                 .filter{ $0.isEmpty == false }
                 .observe(on: MainScheduler.instance)
                 .subscribe(onNext: { [weak self] city in
                   guard let self = self else { return }
                   self.weatherManager.action = .didProvideCity(city)
                 })
                 .disposed(by: disposeBag)
                     
    }
  
  @objc
  func didTapOnSearchButton(_ gesture: UIGestureRecognizer){
    let city = textFieldCity.text
    textFieldCity.text = nil
    weatherManager.action = .didProvideCity(city!)
    textFieldCity.resignFirstResponder()
  }
  
}
