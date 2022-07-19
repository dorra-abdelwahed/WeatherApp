//
//  ResultViewController.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 18/7/2022.
//

import UIKit
import Combine

class ResultViewController: UIViewController {
    
    
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempCurrentLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var feelsTemptLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    var weatherSubscribers = Set<AnyCancellable>()
    private let locationManager = LocationManager.shared
    
    let viewModel = ResultViewModel()
    
    
    private var cityName: String?
    private var lat: Double?
    private var lon: Double?{
        didSet {
            showWeather()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.setupLocationManager()
        locationManager.didUpdatedLocation = { [self] in
            if locationManager.lat != nil {
                lat = locationManager.lat
                lon = locationManager.lon
                Geocoder.geocode(latitude: lat, longitude: lon, completion: { placemark, address, error in
                    self.cityName = address
                })
            } else {
                lat = 41.850029
                lon = -87.650047
                cityName = "Chicago"
            }
        }
        
        
    }
    
    
    func showWeather(){
        
        guard let lat = lat, let lon = lon else {
            return
        }
        
        viewModel.fetchWeather(lon: lon, lat: lat)
            .receive(on: DispatchQueue.main)
            .sink (receiveCompletion: { (completion) in
                switch completion{
                    
                case .finished:
                    
                    break
                case .failure(let error):
                    
                    print(error)
                    
                }
                
            }, receiveValue: {weather in
                
                self.setupWeatherInfoUI(weather: weather)
                
            })
            .store(in: &weatherSubscribers)
        
    }
    
    
    private func presentViewController(){
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "FindViewController") as? FindViewController else { return }
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    private func setupWeatherInfoUI(weather: WeatherResponse) {
        
        self.pressureLabel.text = "Pressure: \(weather.main.pressure) hPa"
        self.tempCurrentLabel.text = String(format: "%.0f°", weather.main.temperature)
        self.humidityLabel.text = "Humidity: \(weather.main.humidity)%"
        self.maxTempLabel.text = String(format: "%.0f°", weather.main.maxTemperature)
        self.minTempLabel.text = String(format: "%.0f°", weather.main.minTemperature)
        self.feelsTemptLabel.text = String(format: "Feels like: %.0f°", weather.main.feelsTemperature)
        self.cityNameLabel.text = cityName
        
        
        //Change background color with animation
        weather.main.temperature > 25 ?
        //green color
        viewModel.animationBakcgroundColor(red: 158, green: 188, blue: 151, vc:self) :
        //blue color
        viewModel.animationBakcgroundColor(red: 58, green: 180, blue: 151, vc:self)
        
    }
    
    
    
    
    @IBAction func search(_ sender: Any) {
        presentViewController()
    }
    
}

extension ResultViewController: SearchTableViewControllerDelegate {
    func setValue(lat: Double, lon: Double, cityName: String) {
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
    }
}

