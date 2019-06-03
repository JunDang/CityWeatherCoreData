//
//  Double+extension.swift
//  CityWeather-3
//
//  Created by Yinhuan Yuan on 5/14/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import Foundation
extension Double {
    func roundToInt() -> Int {
        return Int(self.rounded())
    }
}
