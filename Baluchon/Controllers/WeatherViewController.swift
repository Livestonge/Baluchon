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
  
  var weatherViewModel: WeatherViewModel!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    gestureRecognizerSearchImage.addTarget(self, action: #selector(didTapOnSearchButton))
    
    textFieldCity.rx.controlEvent([.editingDidEndOnExit])
                 .map{ self.textFieldCity.text ?? ""}
                 .filter{ $0.isEmpty == false }
                 .observe(on: MainScheduler.instance)
                 .subscribe(onNext: { [weak self] city in
                   guard let self = self else { return }
                   self.weatherViewModel.action = .didProvideCity(city)
                 })
                 .disposed(by: disposeBag)
    
    let weatherObserver = weatherViewModel.getStateChanges()
                                          .share(replay: 1)
    
    weatherObserver.map(\.localWeather.locationName)
                    .filter{ $0.isEmpty == false }
                    .subscribe(onNext: { [weak self] city in
                      self?.textFieldCity.text = city
                      // DIsmiss if an alert is on screen.
                      self?.dismiss(animated: true)
                    })
                    .disposed(by: disposeBag)
    
    weatherObserver.map(\.localWeather.temperature)
                   .subscribe(onNext: { [weak self] temp in
                     self?.labelTemperature.text = "\(Int(temp.rounded()))ºC"
                   })
                   .disposed(by: disposeBag)
    
    weatherObserver.map(\.localWeather.humidity)
                   .subscribe(onNext: { [weak self] humidity in
                     self?.labelHumidity.text = "\(humidity)%"
                   })
                   .disposed(by: disposeBag)
    
    weatherObserver.map(\.localWeather.description.description)
                   .subscribe(onNext: { [weak self] description in
                     self?.labelWeatherDescription.text = description.capitalized
                   })
                   .disposed(by: disposeBag)
    
    weatherObserver.map(\.localWeather.description.icon)
                   .subscribe(onNext: { [weak self] icon in
                     self?.labelIcon.text = icon
                   })
                   .disposed(by: disposeBag)
    
    weatherObserver.map(\.error)
                   .filter{ $0 != nil }
                   .subscribe(onNext: { [weak self] error in
                     self?.presentAlertFor(error!)
                   })
                   .disposed(by: disposeBag)
                     
    }
  
  @objc
  func didTapOnSearchButton(_ gesture: UIGestureRecognizer){
    let city = textFieldCity.text
    textFieldCity.text = nil
    weatherViewModel.action = .didProvideCity(city!)
    textFieldCity.resignFirstResponder()
  }
  
  private func presentAlertFor(_ error: BaluchonError){
    let alertCtrl = BaluchonAlert(error: error).controller
    self.present(alertCtrl, animated: true)
  }
  
}
