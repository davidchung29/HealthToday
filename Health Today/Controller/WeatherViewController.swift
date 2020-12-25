
//
//  ViewController.swift
//  Health Today
//
//  Created by David Chung

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, covidManagerDelegate{

    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var Health: UILabel!
    @IBOutlet weak var Risk: UILabel!
    
    @IBOutlet weak var WeatherView: UIStackView!
    @IBOutlet weak var HealthView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
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
    
    var windSpeed: String?
    var visibility: String?
    var dewPoint: String?
    
    var lat: Double?
    var lon: Double?
    
    lazy var InfoLayout = [
        "\(uviString ?? "----") - \(uviSafety ?? "----") \n UV Index",
        "\(HumidityString ?? "----")",
        "\(PressureString ?? "----")",
        "\(windSpeed ?? "----")MPH \n Wind",
        "\(visibility ?? "----")M \n Visibility",
        "\(stringSunriseDate ?? "-----")",
        "\(stringSunsetDate ?? "-----")"
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        
        
        tableView.dataSource = self
        
        //make label look good
        HealthView.layer.cornerRadius = 15
        HealthView.layer.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.35).cgColor
        
        tableView.layer.cornerRadius = 35
        tableView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.35)
        
        
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
            
            self.Health.text = "\(covidInfo.CaseDensitySafety)"
            self.Risk.text = " \(covidInfo.InfectionRateString)% "
            self.CovidInfection = covidInfo.InfectionRateString
            self.CaseDensity = covidInfo.CaseDensityString
            self.tableView.reloadData()
        }
         
    }
    
    func didFailCovid(error: Error) {
        print(error)
    }
//    @IBAction func viewDataPressed(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "goToInfo", sender: self)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "goToInfo"{
//            let destinationVC = segue.destination as! infoViewController
//            destinationVC.Risk = CovidInfection
//            destinationVC.caseDensity = CaseDensity
//            destinationVC.Date = Date
//            destinationVC.stringSunriseDate = stringSunriseDate
//            destinationVC.stringSunsetDate = stringSunsetDate
//            destinationVC.TemperatureString = TemperatureString
//            destinationVC.FeelsLikeString = FeelsLikeString
//            destinationVC.PressureString = PressureString
//            destinationVC.HumidityString = HumidityString
//            //destinationVC.humiditySafety = humiditySafety
//            destinationVC.uviString = uviString
//            destinationVC.uviSafety = uviSafety
//            destinationVC.windSpeed = windSpeed
//            destinationVC.visibility = visibility
//            destinationVC.dewPoint = dewPoint
//        }
//    }
    

}
extension WeatherViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return InfoLayout.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
        cell.textLabel?.text = InfoLayout[indexPath.row]
        
        return cell
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
            infoManager.fetchInfoWeather(latitude: lat ?? 0, longitute: lon ?? 0)
            
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
            self.lat = weather.lat
            self.lon = weather.lon
            print("requested lon\(self.lon ?? 1), lat\(self.lat ?? 1)")
            
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
            self.stringSunriseDate = "\(stringSunriseDate) \n Sunrise"
            self.stringSunsetDate = "\(stringSunsetDate) \n Sunset"
            
            self.TemperatureString = "Temp: \(weatherInfo.TemperatureString)F"
            self.FeelsLikeString = "Feels like: \n \(weatherInfo.FeelsLikeString)F "
            
            self.PressureString = "\(weatherInfo.PressureString)hPa\n Pressure"
            self.HumidityString = "\(weatherInfo.HumidityString)%-\(weatherInfo.humiditySafety)\n Humidity"
            
            self.uviString = "\(weatherInfo.uviString)"
            self.uviSafety = "\(weatherInfo.uviSafety)"
            
            self.windSpeed = "\(weatherInfo.windSpeedString)"
            self.visibility = "\(weatherInfo.Visibility)"
            self.dewPoint = "\(weatherInfo.DewPoint)F\n Dew Point"
            
            self.InfoLayout = [
                "\(self.uviString ?? "----") - \(self.uviSafety ?? "----") \n UV Index",
                "\(self.HumidityString ?? "----")",
                "\(self.PressureString ?? "----")",
                "\(self.windSpeed ?? "----")MPH \n Wind",
                "\(self.visibility ?? "----")M \n Visibility",
                "\(self.stringSunriseDate ?? "-----")",
                "\(self.stringSunsetDate ?? "-----")"
            ]
            self.tableView.reloadData()

        }
    }
    func didFailWithInfo(error: Error) {
        print(error)
    }
}
