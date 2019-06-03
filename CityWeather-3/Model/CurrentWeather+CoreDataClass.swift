//
//  CurrentWeather+CoreDataClass.swift
//  
//
//  Created by Yinhuan Yuan on 5/14/19.
//
//

import Foundation
import CoreData

@objc(CurrentWeather)
public class CurrentWeather: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrentWeather> {
        return NSFetchRequest<CurrentWeather>(entityName: "CurrentWeather")
    }
    @NSManaged public var cityID: Int64
    @NSManaged public var cityName: String?
    @NSManaged public var icon: String?
    @NSManaged public var maxTempCelcius: Double
    @NSManaged public var minTempCelcius: Double
    @NSManaged public var tempCelcius: Double
    @NSManaged public var time: Int64
    @NSManaged public var weatherDescription: String?
    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var humidity: Double


}
