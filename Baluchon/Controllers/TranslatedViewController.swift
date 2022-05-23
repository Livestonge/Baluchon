//
//  TranslatedViewController.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 04/02/2022.
//

import UIKit

class TranslatedViewController: UIViewController {

  @IBOutlet weak var textViewSource: UITextView!
  @IBOutlet weak var textViewTranslated: UITextView!
  @IBOutlet weak var viewEnglishTitle: UIView!
  @IBOutlet weak var viewFrenchTitle: UIView!
  
  var translatedText = ""
  var sourceText = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textViewSource.sizeToFit()
    textViewSource.layer.cornerRadius = 20
    textViewSource.clipsToBounds = true
    
    textViewTranslated.sizeToFit()
    textViewTranslated.layer.cornerRadius = 20
    textViewTranslated.clipsToBounds = true
    
    textViewTranslated.text = translatedText
    textViewSource.text = sourceText
    
    let labelFrench = UILabel()
    let labelEnglish = UILabel()
    
    labelFrench.text = "French"
    
    
    labelEnglish.text = "English"
    
    
    labelFrench.backgroundColor = .yellow
    labelFrench.textAlignment = .center
    labelEnglish.backgroundColor = .yellow
    labelEnglish.textAlignment = .center
    
    labelFrench.layer.cornerRadius = 10
    labelFrench.clipsToBounds = true
    
    labelEnglish.layer.cornerRadius = 10
    labelEnglish.clipsToBounds = true
    
    labelFrench.translatesAutoresizingMaskIntoConstraints = false
    labelEnglish.translatesAutoresizingMaskIntoConstraints = false
    
    viewFrenchTitle.addSubview(labelFrench)
    
    NSLayoutConstraint.activate([
      labelFrench.centerXAnchor.constraint(equalTo: viewFrenchTitle.centerXAnchor),
      labelFrench.centerYAnchor.constraint(equalTo: viewFrenchTitle.centerYAnchor),
      labelFrench.widthAnchor.constraint(equalTo: viewFrenchTitle.widthAnchor, multiplier: 0.3)
    ])
    viewEnglishTitle.addSubview(labelEnglish)
    
    NSLayoutConstraint.activate([
      labelEnglish.centerXAnchor.constraint(equalTo: viewEnglishTitle.centerXAnchor),
      labelEnglish.centerYAnchor.constraint(equalTo: viewEnglishTitle.centerYAnchor),
      labelEnglish.widthAnchor.constraint(equalTo: viewEnglishTitle.widthAnchor, multiplier: 0.3)
    ])
    
    
  }

}
