//
//  WeatherInformation.swift
//  Weather
//
//  Created by do hee kim on 2022/03/25.
//

import Foundation

struct WeatherInformation: Codable {
    let weather: [Weather]
    let temp: Temp //JSON key 중 "main" key와 맵핑되어야 함
    let name: String //도시 이름을 가져올 수 있게
    
    enum CodingKeys: String, CodingKey {
        case weather
        case temp = "main"
        case name
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Temp: Codable {
    let temp: Double
    let feelsLike: Double
    let minTemp: Double
    let maxTemp: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
    }
}
