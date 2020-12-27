
//
//  ViewController.swift
//  Health Today
//
//  Created by David Chung

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, covidManagerDelegate,WeatherManagerDelegate{

    
    
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
    var windClass: String?
    var knots: String?
    var visibility: String?
    var dewPoint: String?
    
    var lat: Double?
    var lon: Double?
    
    
    lazy var InfoLayout: [Information] = [
        Information(sender: K.Info.UVI , body: "\(uviString ?? "----")  \(uviSafety ?? "----") \n UV Index"),
        Information(sender: K.Info.Humidity, body: "\(HumidityString ?? "----")"),
        Information(sender: K.Info.Pressure, body: "\(PressureString ?? "----")"),
        Information(sender: K.Info.WindSpeed, body: "\(windSpeed ?? "----")MPH \n Wind"),
        Information(sender: K.Info.Visibility, body: "\(visibility ?? "----")M \n Visibility"),
        Information(sender: K.Info.DewPoint, body: "\(dewPoint ?? "-----")F"),
        Information(sender: K.Info.Sunrise, body: "\(stringSunriseDate ?? "-----")"),
        Information(sender: K.Info.Sunset, body: "\(stringSunsetDate ?? "-----")")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        print("loaded")
        
        
        tableView.dataSource = self
        
        //make label look good
        HealthView.layer.cornerRadius = 35
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
        
        tableView.register(UINib(nibName: "InfoCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        //hides extra table view cells by createing a uiview over it
        tableView.tableFooterView = UIView()
        
    }
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = "\(weather.temperatureString)°F"
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
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
//        cell.textLabel?.text = InfoLayout[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! InfoCell
        cell.infoLabel.text = InfoLayout[indexPath.row].body
        cell.infoDescription.text = InfoLayout[indexPath.row].sender
        
        switch InfoLayout[indexPath.row].sender {

        case K.Info.UVI:
            cell.infoView?.image = #imageLiteral(resourceName: "UVI")
        case K.Info.Humidity:
            cell.infoView?.image = #imageLiteral(resourceName: "Hygrometer")
        case K.Info.Pressure:
            cell.infoView?.image = #imageLiteral(resourceName: "pressure")
        case K.Info.WindSpeed:
            cell.infoView?.image = UIImage(named: "Wind\(windClass ?? "0")" )
        case K.Info.Visibility:
            cell.infoView?.image = #imageLiteral(resourceName: "Visibility")
        case K.Info.DewPoint:
            cell.infoView?.image = #imageLiteral(resourceName: "dewPoint")
        case K.Info.Sunrise:
            cell.infoView?.image = #imageLiteral(resourceName: "sunrise")
        case K.Info.Sunset:
            cell.infoView?.image = #imageLiteral(resourceName: "sunset")
            
        default:
            print("unknown sender")
        }
            
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
            self.tableView.reloadData()
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

extension WeatherViewController: infoManagerDelegate{

    func didUpdateWeatherInfo(_ infoManager: InfoManager, weatherInfo: infoModel) {
        DispatchQueue.main.async { [self] in
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
            self.stringSunriseDate = "\(stringSunriseDate)"
            self.stringSunsetDate = "\(stringSunsetDate)"
            
            self.TemperatureString = "\(weatherInfo.TemperatureString)°F"
            self.FeelsLikeString = "Feels like: \n \(weatherInfo.FeelsLikeString)°F "
            
            self.PressureString = "\(weatherInfo.PressureString)hPa"
            self.HumidityString = "\(weatherInfo.HumidityString)% \(weatherInfo.humiditySafety)"
            
            self.uviString = "\(weatherInfo.uviString)"
            self.uviSafety = "\(weatherInfo.uviSafety)"
            
            self.windSpeed = "\(weatherInfo.windSpeedString)"
            self.windClass = "\(weatherInfo.windClass)"
            self.knots = "\(weatherInfo.knots)"
            self.visibility = "\(weatherInfo.visibilityString)"
            self.dewPoint = "\(weatherInfo.DewPoint)°F"
            
            self.InfoLayout = [
                Information(sender: K.Info.UVI , body: "\(self.uviString ?? "----") \(self.uviSafety ?? "----")"),
                Information(sender: K.Info.Humidity, body: "\(self.HumidityString ?? "----")"),
                Information(sender: K.Info.Pressure, body: "\(self.PressureString ?? "----")"),
                Information(sender: K.Info.WindSpeed, body: "\(self.knots ?? "----") MPH"),
                Information(sender: K.Info.Visibility, body: "\(self.visibility ?? "----") Miles"),
                Information(sender: K.Info.DewPoint, body: "\(self.dewPoint ?? "-----")°F"),
                Information(sender: K.Info.Sunrise, body: "\(stringSunriseDate )"),
                Information(sender: K.Info.Sunset, body: "\(stringSunsetDate )")
            ]
            self.tableView.reloadData()

        }
    }
    func didFailWithInfo(error: Error) {
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



