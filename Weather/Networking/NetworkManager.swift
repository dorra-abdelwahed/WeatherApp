//
//  NetworkManager.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 13/7/2022.
//

import Foundation
import Combine




// MARK: - WeatherFetcher

//MARK: Protocol
protocol WeatherFetcherProtocol {
   
    func currentWeatherForecast(forCity city: String) -> AnyPublisher<[SearchResultResponse],NetworkError>
    
    func currentWeatherForecast(lon: Double, lat: Double) -> AnyPublisher<WeatherResponse,NetworkError>
}

//MARK: Class
class WeatherFetcher {
  private let session: URLSession
  
  init(session: URLSession = .shared) {
    self.session = session
  }
}

//MARK: WeatherFetcherProtocol
extension WeatherFetcher: WeatherFetcherProtocol{
    
    
  
    func currentWeatherForecast(forCity city: String) -> AnyPublisher<[SearchResultResponse], NetworkError> {
        
        return request(with: OpenWeatherAPI.searchText(withCity: city))
    }
    
    func currentWeatherForecast(lon: Double, lat: Double) -> AnyPublisher<WeatherResponse,NetworkError>{
        
        return request(with: OpenWeatherAPI.WeatheFor(lon: lon, lat: lat))
    }
    
    func request<T: Decodable>(with components: URLComponents) -> AnyPublisher<T,NetworkError>{
        
        ///get url else handler error
        guard let url = components.url else {
            let error = NetworkError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        let URL = URLRequest(url: url)
        
        
        return session.dataTaskPublisher(for: URL)
            .mapError { error in
                .network(description: error.localizedDescription)
            }.flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
              }
              .eraseToAnyPublisher()
            
        
    }
    
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, NetworkError> {
      
        let decoder = JSONDecoder()

      return Just(data)
        .decode(type: T.self, decoder: decoder)
        .mapError { error in
          .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
    
}
    


// MARK: - OpenWeatherMap API

struct OpenWeatherAPI {
    
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let key = "eafc80478b2fbd7f5b6b52f153aac652"
    
  
    
     static func searchText(
      withCity city: String
    ) -> URLComponents {
      var components = URLComponents()
      components.scheme = OpenWeatherAPI.scheme
      components.host = OpenWeatherAPI.host
      components.path = "/geo/1.0/direct"
      
      components.queryItems = [
        URLQueryItem(name: "q", value: city),
        URLQueryItem(name: "limit", value: "10"),
        URLQueryItem(name: "mode", value: "json"),
        URLQueryItem(name: "units", value: "metric"),
        URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
      ]
      
      return components
    }
    
    static func WeatheFor(
      lon: Double,
      lat: Double
   ) -> URLComponents {
     var components = URLComponents()
     components.scheme = OpenWeatherAPI.scheme
     components.host = OpenWeatherAPI.host
     components.path = "/data/2.5/weather"
     
     components.queryItems = [
       URLQueryItem(name: "lon", value: String(lon)),
       URLQueryItem(name: "lat", value: String(lat)),
       URLQueryItem(name: "mode", value: "json"),
       URLQueryItem(name: "units", value: "metric"),
       URLQueryItem(name: "APPID", value: OpenWeatherAPI.key)
     ]
     
     return components
   }
}

