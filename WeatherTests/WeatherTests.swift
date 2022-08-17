//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Dorra Ben Abdelwahed on 19/7/2022.
//

import XCTest
import Combine
@testable import Weather

class WeatherTests: XCTestCase {

    let weatherFetcher = WeatherFetcher()
    let resultVM = ResultViewModel()
    let findVM = FindViewModel()
    
    private var cancellables: Set<AnyCancellable>!

    
    override func setUp() {
           super.setUp()
           cancellables = []
       }
   

    func testCurrentWeather()  {
      
        let expectation = XCTestExpectation(description: "Download some data")
        
        weatherFetcher.currentWeatherForecast(lon: 35.0, lat: 35.0)
            .sink (receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
                expectation.fulfill()
                
            }, receiveValue: {
                res in
                XCTAssertNotNil(res, "data was downloaded.")
                
            }).store(in: &cancellables)
            
            wait(for: [expectation], timeout: 10.0)
    }

    
    func testSearchCity()  {
      
        let expectation = XCTestExpectation(description: "Download some data")
        
        weatherFetcher.SearchCity(forCity: "Paris")
            .sink (receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
                expectation.fulfill()
                
            }, receiveValue: {
                res in
                XCTAssertNotNil(res, "data was downloaded.")
                
            }).store(in: &cancellables)
            
            wait(for: [expectation], timeout: 10.0)
    }

}
