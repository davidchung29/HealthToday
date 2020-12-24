//
//  infoModel.swift
//
//  Created by David Jr on 12/2/20.
//

import Foundation

struct infoModel{
    let Sunrise: Double
    let Sunset: Double
    let Temperature: Double
    let FeelsLike: Double
    let Pressure: Int
    let Humidity: Int
    let uviValue: Double
    let windSpeed:Double
    let Visibility: Double
    let DewPoint: Double
    
    var TemperatureString: String{
        String(format: "%.1f", Temperature)
    }
    var FeelsLikeString: String{
        String(format: "%.1f", FeelsLike)
    }
    var PressureString: String{
        String(Pressure)
    }
    var HumidityString:String{
        String(Humidity)
    }
    var uviString: String{
        String(uviValue)
    }
    var windSpeedString: String{
        String(windSpeed)
    }
    var uviSafety:String{
        switch uviValue {
        case 0.0..<3.0:
            return "Low"
        case 3.0..<8.0:
            return "Moderate to High"
        default:
            return "Very High to Extreme"
        }
    }
    var humiditySafety:String{
        switch Humidity {
        case 45...55:
            return "Normal"
        case 0..<45:
            return "Dry"
        default:
            return "Humid"
        }
    }
}
