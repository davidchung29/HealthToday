//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//
//        z
//        weather_manager.delegate = self
//        searchTextField.delegate = self
//
//        let gradientLayer = CAGradientLayer()
//        // Set the size of the layer to be equal to size of the display.
//        gradientLayer.frame = view.bounds
//        // Set an array of Core Graphics colors (.cgColor) to create the gradient.
//        // This example uses a Color Literal and a UIColor from RGB values.
//        gradientLayer.colors = [#colorLiteral(red: 0, green: 0.5725490196, blue: 0.2705882353, alpha: 1).cgColor, UIColor(red: 252/255, green: 238/255, blue: 33/255, alpha: 1).cgColor]
//        // Rasterize this static layer to improve app performance.
//        gradientLayer.shouldRasterize = true
//        // Apply the gradient to the backgroundGradientView.
//        backgroundView.layer.addSublayer(gradientLayer)

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, covidManagerDelegate{

    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var viewDataButton: UIButton!
    @IBOutlet weak var covidHealth: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    var fipsManager = getFipsManager()
    var CovidManager = covidManager()
    var infoManager = InfoManager()
    
    var CovidInfection: String?
    var CaseDensity: String?
    
    var Date: String?
    var stringSunriseDate: String?
    var stringSunsetDate: String?
    
    var TemperatureString: String?
    var FeelsLikeString: String?
    
    var PressureString: String?
    
    var HumidityString: String?
    var humiditySafety: String?
    
    var uviString: String?
    var uviSafety: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make button look good.
        viewDataButton.layer.cornerRadius = 10
        viewDataButton.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.43)
        
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        fipsManager.delegate = self
        CovidManager.delegate = self
        infoManager.delegate = self
        
    }
    func didUpdateCovid(_ covidManager: covidManager, covidInfo: covidModel) {
        
        DispatchQueue.main.async {
            
            self.covidHealth.text = "\(covidInfo.CaseDensitySafety)"
            self.CovidInfection = covidInfo.InfectionRateString
            self.CaseDensity = covidInfo.CaseDensityString
        }
         
    }
    
    func didFailCovid(error: Error) {
        print(error)
    }
    @IBAction func viewDataPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToInfo"{
            let destinationVC = segue.destination as! infoViewController
            destinationVC.covidInfection = CovidInfection
            destinationVC.caseDensity = CaseDensity
            destinationVC.Date = Date
            destinationVC.stringSunriseDate = stringSunriseDate
            destinationVC.stringSunsetDate = stringSunsetDate
            destinationVC.TemperatureString = TemperatureString
            destinationVC.FeelsLikeString = FeelsLikeString
            destinationVC.PressureString = PressureString
            destinationVC.HumidityString = HumidityString
            destinationVC.humiditySafety = humiditySafety
            destinationVC.uviString = uviString
            destinationVC.uviSafety = uviSafety
        }
    }
    

}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
        
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: lon)
            fipsManager.fetchInfoFips(latitude: lat, longitute: lon)
            infoManager.fetchInfoWeather(latitude: lat, longitute: lon)
            print("lat:\(lat), lon:\(lon)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension WeatherViewController: getFipsManagerDelegate{
    func didUpdateFips(_ getFipsManager: getFipsManager, fipsInfo: getFipsModel) {
        DispatchQueue.main.async {
            print(fipsInfo.fipsData)
            self.CovidManager.fetchCovid(fipsCode: fipsInfo.fipsData)
        }
    }
    func didFailWithFips(error: Error) {
        print(error)
    }
}


extension WeatherViewController: infoManagerDelegate{

    func didUpdateWeatherInfo(_ infoManager: InfoManager, weatherInfo: infoModel) {
        DispatchQueue.main.async {
            let sunriseDate = NSDate(timeIntervalSince1970: weatherInfo.Sunrise)
            let sunsetDate = NSDate(timeIntervalSince1970: weatherInfo.Sunset)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm:ss a"
            let Date = dateFormatter.string(from: sunriseDate as Date)
            let stringSunriseDate = timeFormatter.string(from: sunriseDate as Date)
            let stringSunsetDate = timeFormatter.string(from: sunsetDate as Date)
            
            self.Date = "Date: \(Date)"
            self.stringSunriseDate = "Sunrise: \n\(stringSunriseDate)"
            self.stringSunsetDate = "Sunset: \n\(stringSunsetDate)"
            
            self.TemperatureString = "Temp: \(weatherInfo.TemperatureString)F"
            self.FeelsLikeString = "Feels like: \(weatherInfo.FeelsLikeString)F"
            
            self.PressureString = "\(weatherInfo.PressureString)hPa"
            self.HumidityString = "\(weatherInfo.HumidityString)%"
            self.humiditySafety = "\(weatherInfo.humiditySafety)"
            
            self.uviString = "\(weatherInfo.uviString)"
            self.uviSafety = "\(weatherInfo.uviSafety)"
            

        }
    }
    func didFailWithInfo(error: Error) {
        print(error)
    }
}
