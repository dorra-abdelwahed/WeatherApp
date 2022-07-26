//
//  LocationManager.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 18/7/2022.
//

import CoreLocation

class LocationManager: CLLocationManager, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    var lat, lon: Double?
    
    var didUpdatedLocation: (() -> ())?
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            
            didUpdatedLocation?()
        }
    }
}
