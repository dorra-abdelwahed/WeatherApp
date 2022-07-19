//
//  SearchResultResponse.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 18/7/2022.
//

import Foundation


struct SearchResultResponse: Codable {
    
    let name: String?
    let lat: Double?
    let lon: Double?
    let country: String?
    let state: String?
    
}
