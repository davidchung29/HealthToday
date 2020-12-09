//
//  covidData.swift
//  Clima
//
//  Created by David Jr on 12/6/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct covidData: Decodable{
    let metrics: Metrics
    
}

struct Metrics: Decodable{
    let infectionRate: Double
    let caseDensity: Double
}
