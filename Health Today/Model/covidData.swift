//
//  covidData.swift
//
//  Created by David Jr on 12/6/20.
//

import Foundation

struct covidData: Decodable{
    let metrics: Metrics
}

struct Metrics: Decodable{
    let infectionRate: Double
    let caseDensity: Double
}
