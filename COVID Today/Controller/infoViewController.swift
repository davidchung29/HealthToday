//
//  infoViewController.swift
//  Clima
//
//  Created by David Jr on 12/2/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class infoViewController: UIViewController{
    //  label/buttons
    @IBOutlet weak var backLabel: UIButton!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var feelsLike: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var pressureStringLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!
    @IBOutlet weak var uviSafetyLabel: UILabel!
    @IBOutlet weak var humiditySafetyLabel: UILabel!
    @IBOutlet weak var covidLabel: UILabel!
    @IBOutlet weak var caseDensityLabel: UILabel!
    
    @IBOutlet weak var uviStringLabel: UILabel!
    @IBOutlet weak var humidityStringLabel: UILabel!
    @IBOutlet weak var covidView: UIView!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var uviView: UIView!
    @IBOutlet weak var SunView: UIView!
    
    
    var covidInfection:String?
    var caseDensity: String?
    
    let locationManager = CLLocationManager()
    var covidHealth = "nil"
    
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
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //label Aesthetics
        
        //view Aesthetics
        uviView.layer.cornerRadius = 30
        uviView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.49)
        
        SunView.layer.cornerRadius = 30
        SunView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.49)
        
        tempView.layer.cornerRadius = 30
        tempView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.49)
        
        
//
//        pressureStringLabel.layer.cornerRadius = 10
//        pressureStringLabel.layer.backgroundColor=UIColor.systemGray2.withAlphaComponent(0.53).cgColor
//
//        humidityStringLabel.layer.cornerRadius = 10
//        humidityStringLabel.layer.backgroundColor=UIColor.systemGray2.withAlphaComponent(0.53).cgColor
//
//        uviStringLabel.layer.cornerRadius = 10
//        uviStringLabel.layer.backgroundColor=UIColor.systemGray2.withAlphaComponent(0.53).cgColor
        
        
        pressureView.layer.cornerRadius = 20
        pressureView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.49)
        
        humidityView.layer.cornerRadius = 20
        humidityView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.49)
        
        covidView.layer.cornerRadius = 20
        covidView.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.49)
        //backLabel Aesthetics
        backLabel.layer.cornerRadius = 10
        backLabel.backgroundColor=UIColor.systemGray3.withAlphaComponent(0.43)
        

        self.covidLabel.text = "Infection Rate: \(covidInfection ?? "----")%"
        self.caseDensityLabel.text = "\(caseDensity ?? "----")/100,000 Infected"
        
        self.dateLabel.text = "\(Date ?? "----")"
        self.sunriseLabel.text = "\(stringSunriseDate ?? "----")"
        self.sunsetLabel.text = "\(stringSunsetDate ?? "----")"
    
        self.tempLabel.text = "\(TemperatureString ?? "----")"
        self.feelsLike.text = "\(FeelsLikeString ?? "----")"
        self.pressureLabel.text = "\(PressureString ?? "----")"
        self.humidityLabel.text = "\(HumidityString ?? "----")"
        self.humiditySafetyLabel.text = "\(humiditySafety ?? "----")"
        
        self.uviLabel.text = "\(uviString ?? "----")"
        self.uviSafetyLabel.text = "\(uviSafety ?? "----")"
        
    }
    

}





