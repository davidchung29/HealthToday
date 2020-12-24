//
//  infoData.swift
//
//  Created by David Jr on 12/2/20.
//

import Foundation

struct infoData: Decodable{
    let current: Current

}
struct Current: Decodable{
    let sunrise: Double
    let sunset: Double
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let uvi: Double

    let wind_speed: Double
    let visibility: Double
    let dew_point: Double
//    let wind_gust: Double
}

