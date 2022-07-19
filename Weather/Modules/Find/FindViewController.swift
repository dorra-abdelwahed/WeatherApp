//
//  ViewController.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 13/7/2022.
//

import UIKit
import CoreLocation
import Combine

class FindViewController: UIViewController {

    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    private var locationManager:CLLocationManager?

   
 
    let weatherFetcher = WeatherFetcher()
    let viewModel = FindViewModel()
    
    var weather: Main?
    var delegate: SearchTableViewControllerDelegate?

    
    private var weatherSubscribers = Set<AnyCancellable>()
    private var city = Set<AnyCancellable>()
    
    var longitude: Double?
    var latitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupTableView()
        viewModel.listenerForSearchQuery()
       
    }
    
   
    
 
    func setupTableView(){
        
        //register cell table view
        let nib = UINib(nibName: "AdressTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AdressCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @IBAction func updateTextField(_ sender: UITextField) {
        
        
        viewModel.searchQuery = sender.text ?? ""
        tableView.reloadData()
        
    }
    
//    func getWeather(lon: String, lat: String){
//
//        weatherFetcher
//            .currentWeatherForecast(lon: lon, lat: lat)
//            .sink(receiveCompletion: { completion in
//                switch completion{
//
//                case .finished:
//                    print("finished")
//                    break
//                case .failure(let error):
//
//                  print(error)
//                self.weatherArray = []
//                }
//            }, receiveValue: { weather in
//
//                self.weather = weather.main
//            })
//            .store(in: &weatherSubscribers)
//
//    }

}


extension FindViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AdressCell", for: indexPath) as? AdressTableViewCell else { return UITableViewCell() }
        cell.configure(adress: viewModel.resultArray[indexPath.row])
        return cell
    }
    
    
}

extension FindViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! AdressTableViewCell
        guard let lat = selectedCell.lat,
              let lon = selectedCell.lon,
              let cityName = selectedCell.titleLbl.text
        else { return }
        delegate?.setValue(lat: lat, lon: lon, cityName: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
}
