//
//  WeatherData.swift
//
//  Created by David Jr on 11/25/20.
//

import Foundation
 
struct WeatherData: Decodable{
    let name:String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable{
    let temp: Double
}
struct Weather: Decodable{
    let description: String
    let id: Int
}
