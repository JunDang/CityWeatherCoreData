//
//  WeatherDetailsViewController.swift
//  CityWeather-3
//
//  Created by Yinhuan Yuan on 5/14/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit

class WeatherDetailsViewController: UIViewController {

    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var lowTempLbl: UILabel!
    @IBOutlet weak var highTempLbl: UILabel!
    
    var weather: CurrentWeather?

    override func viewDidLoad() {
        super.viewDidLoad()
        guard weather != nil else {
            return
        }
        self.navigationItem.title = weather!.cityName
        if let iconString = weather!.icon {
            let iconURL = URL(string: "http://openweathermap.org/img/w/\(iconString).png")!
            let imageData = try? Data(contentsOf: iconURL)
            if let imageDataUnwrapped = imageData {
                weatherImage.image = UIImage(data: imageDataUnwrapped)
            }
        }
        weatherDescription.text = weather!.weatherDescription
        temperatureLbl.text = String(weather!.tempCelcius.roundToInt()) + "°C"
        lowTempLbl.text = String(weather!.minTempCelcius.roundToInt()) + "°C"
        highTempLbl.text = String(weather!.maxTempCelcius.roundToInt()) + "°C"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
