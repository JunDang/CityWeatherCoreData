//
//  UITableViewCell + extension.swift
//  CityWeather-3
//
//  Created by Yinhuan Yuan on 5/14/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import Foundation
import UIKit

extension UITableViewCell {
    func configure(_ weather: CurrentWeather) {
        self.textLabel?.text = weather.cityName
        // Info parts
        var weatherDetails: [String] = []
        // Weather description
        if let weatherDescription = weather.weatherDescription {
            weatherDetails.append(weatherDescription)
        }
        // Tempature
        weatherDetails.append("🌡 \(weather.tempCelcius.roundToInt())°C")
        self.detailTextLabel?.text = weatherDetails.joined(separator: "    ")
        //Weather icon
        if let iconString = weather.icon {
            let iconURL = URL(string: "http://openweathermap.org/img/w/\(iconString).png")!
            let imageData = try? Data(contentsOf: iconURL)
            if let imageDataUnwrapped = imageData {
                self.imageView?.image = UIImage(data: imageDataUnwrapped)
            }
        }
        
    }
}
