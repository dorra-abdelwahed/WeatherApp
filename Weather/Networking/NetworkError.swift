//
//  NetworkError.swift
//  Mini_Project
//
//  Created by Dorra Ben Abdelwahed on 13/7/2022.
//

import Foundation


enum NetworkError: Error {
    case parsing(description: String)
    case network(description: String)
}
