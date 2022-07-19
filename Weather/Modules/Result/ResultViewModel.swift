//
//  ResultViewModel.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 18/7/2022.
//

import UIKit
import CoreLocation
import Combine


class ResultViewModel{
    
    
    func animationBakcgroundColor(red: CGFloat, green: CGFloat, blue: CGFloat,vc: UIViewController){
        UIView.animate(withDuration: 1.0, delay: 0.0,  animations: {
            vc.view.backgroundColor = UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        }, completion:nil)
    }
    
    func fetchWeather(lon: Double, lat: Double) -> AnyPublisher<WeatherResponse,NetworkError>{
        
        return WeatherFetcher().currentWeatherForecast(lon: lon, lat: lat)
        
        
        
    }
}
