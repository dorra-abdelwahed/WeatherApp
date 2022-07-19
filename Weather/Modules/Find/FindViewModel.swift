//
//  FindViewModel.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 18/7/2022.
//

import Foundation
import Combine


class FindViewModel{
    
    @Published var searchQuery: String = ""
    @Published var resultArray: [SearchResultResponse] = []
    
    var weatherSubscribers = Set<AnyCancellable>()
    let weatherFetcher = WeatherFetcher()
    
    
   
    func listenerForSearchQuery(){
        
        $searchQuery
            .sink{ query in
                self.weatherFetchData(for: query)}
            .store(in: &weatherSubscribers)
                
            }
    
    func weatherFetchData(for city: String){
        
        weatherFetcher.currentWeatherForecast(forCity: searchQuery)
            .sink(receiveCompletion: { (completion) in
                switch completion{
                
                case .finished:
                    
                    break
                case .failure(_):
                    
                    self.resultArray = []
                }
            }, receiveValue: { (response) in
               
                self.resultArray = response
            })
            .store(in: &weatherSubscribers)

    }
       
    
}
