//
//  FixerAPIMockData.swift
//  Baluchon
//
//  Created by Awaleh Moussa Hassan on 25/01/2022.
//

import Foundation


let jsonData = """
               {
                   "success":true,
                   "timestamp":1643102523,
                   "historical":true,
                    "date":"2022-01-25",
                   "base":"EUR",
                   "rates":{"USD":1.12986}
               }
 """.data(using: .utf8)


let googleTranslatedData = """
                            {
                                "data":     {
                                    "translations":         [
                                                    {
                                            "model": "nmt",
                                            "translatedText": "Write your text here"
                                        }
                                    ]
                                }
                            }
                            """.data(using: .utf8)

let weatherData = """
{"coord":{"lon":2.3488,"lat":48.8534},"weather":[{"id":801,"main":"Clouds","description":"peu nuageux","icon":"02d"}],"base":"stations","main":{"temp":8.72,"feels_like":5.23,"temp_min":7.53,"temp_max":9.77,"pressure":1020,"humidity":62},"visibility":10000,"wind":{"speed":7.2,"deg":240},"clouds":{"all":20},"dt":1645270937,"sys":{"type":2,"id":2041230,"country":"FR","sunrise":1645253532,"sunset":1645291022},"timezone":3600,"id":2988507,"name":"Paris","cod":200}
""".data(using: .utf8)
