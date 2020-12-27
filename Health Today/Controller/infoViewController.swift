//
//  infoViewController.swift
//
//  Created by David Jr on 12/2/20.
//
//

//import UIKit
//import CoreLocation

//class infoViewController: UIViewController{
//    //  label/buttons
//    @IBOutlet weak var backLabel: UIButton!
//    @IBOutlet weak var sunriseLabel: UILabel!
//    @IBOutlet weak var sunsetLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var feelsLike: UILabel!
//
//    @IBOutlet weak var tableView: UITableView!
//
//
//    var Risk:String?
//    var caseDensity: String?
//
//    let locationManager = CLLocationManager()
//    var covidHealth = "nil"
//
//    var Date: String?
//    var stringSunriseDate: String?
//    var stringSunsetDate: String?
//
//    var TemperatureString: String?
//    var FeelsLikeString: String?
//
//    var PressureString: String?
//
//    var HumidityString: String?
//    var humiditySafety: String?
//
//    var uviString: String?
//    var uviSafety: String?
//
//    var windSpeed: String?
//    var visibility: String?
//    var dewPoint: String?
//    lazy var InfoLayout = [
//        "\(uviString ?? "----") - \(uviSafety ?? "----") \n UV Index",
//        "\(HumidityString ?? "----")",
//        "\(PressureString ?? "----")",
//        "\(windSpeed ?? "----")MPH \n Wind",
//        "\(visibility ?? "----")M \n Visibility",
//        "\(stringSunriseDate ?? "-----")",
//        "\(stringSunsetDate ?? "-----")"
//
//
//
//    ]
//
//
//    @IBAction func backButtonPressed(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.dataSource = self
//
//            //view Aesthetics
//        tableView.layer.cornerRadius = 35
//        tableView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.49)
//
//        backLabel.layer.cornerRadius = 10
//        backLabel.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.43)
//
//        //self.covidLabel.text = "Infection Rate: \(covidInfection ?? "----")%"
//        //self.caseDensityLabel.text = "\(caseDensity ?? "----")/100,000 Infected"
//
//        self.dateLabel.text = "\(Date ?? "-----")"
//        self.sunriseLabel.text = "Infection Rate: \(Risk ?? "----")%"
//        self.sunsetLabel.text = "\(caseDensity ?? "----")/100,000 Infected"
//
//
//
//    }
//
//
//}
//
//extension infoViewController: UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return InfoLayout.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)
//        cell.textLabel?.text = InfoLayout[indexPath.row]
//
//        return cell
//    }
//
//
//}
//



