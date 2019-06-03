//
//  CityWeatherTableTableViewController.swift
//  CityWeather-3
//
//  Created by Jun Dang on 2019-05-12.
//  Copyright © 2019 Jun Dang. All rights reserved.

import UIKit
import CoreData
import GooglePlaces

class CityWeatherTableTableViewController: UITableViewController, SearchCityDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    let progressHUD = ProgressHUD(text: "adding data")
    var currentWeatherSet = [CurrentWeather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fectch city weather data from the core data
        fetchCoreData()
        //set up activity indicator
        view.addSubview(progressHUD)
        progressHUD.backgroundColor = UIColor.black
        progressHUD.hide()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // if the internet is not connected, display the error message
        ReachabilityMonitor.isUnreachable { _ in
            self.disPlayError("Internet is not connected")
        }
    }
  
    func fetchCoreData() {
        
        /*fetch the data from the core data by cityID, if there is weather data saved for the same city ID, then update the weather data for the city, the reason to use city ID is to prevent duplicate data saved for the same city name*/
        
        let fetchRequest : NSFetchRequest<CurrentWeather> =  CurrentWeather.fetchRequest()
        let sor1 =  NSSortDescriptor(key: "cityName", ascending: true)
        let sor2 =  NSSortDescriptor(key: "cityID", ascending: false)
        fetchRequest.sortDescriptors = [sor1, sor2]
        
        let persistentContainer = appDelegate.persistentContainer
        do {
            currentWeatherSet = try persistentContainer.viewContext.fetch(fetchRequest)
            if currentWeatherSet.count >= 1 {
               for i in 0...(currentWeatherSet.count - 1) {
                    APIService.sharedInstance.getCurrentWeather(cityName: currentWeatherSet[i].cityName!)
                        { (forecast, error) in
                           if let forecast = forecast {
                              if (self.currentWeatherSet[i].cityID == Int64(forecast.cityID))
                              {
                                self.updateWeatherDataInCoreData(self.currentWeatherSet[i], updateWith: forecast)
                                                    self.progressHUD.hide()
                                }
                        
                            } else {
                                self.disPlayError(error)
                            }
                            self.tableView.reloadData()
                            self.progressHUD.hide()
                    }
                }
            }
        } catch let error {
            self.disPlayError(error.localizedDescription)
        }
    }
    
    func callAPIServiceAndUpdateUI(_ cityName: String) {
        APIService.sharedInstance.getCurrentWeather(cityName:cityName)
        { (forecast, error) in
            if let forecast = forecast {
                 let fetchRequest : NSFetchRequest<CurrentWeather> =  CurrentWeather.fetchRequest()
            /*fetch the weather data set from core data by the cityID (this is to prevent duplicate cities created in the database, if the data set is empty, then create a new weather in the data base*/
                 fetchRequest.predicate = NSPredicate(format: "cityID == %d",Int64(forecast.cityID))
                do {
                    let context = self.appDelegate.persistentContainer.viewContext
                    let weatherSet = try context.fetch(fetchRequest)
                    if weatherSet.count == 0 {
                        self.createCurrentWeatherEntityFrom(forecast)
                        self.progressHUD.hide()
                    }
                } catch let error {
                    self.disPlayError(error.localizedDescription)
                }
            } else {
                self.disPlayError(error)
            }
        }
    // hide activity indicator
      progressHUD.hide()
    }
    
    // create a weather object in the core data with the data object returned from networking request
    private func createCurrentWeatherEntityFrom(_ forecast: Forecast) {
        let context = appDelegate.persistentContainer.viewContext
        if let weather = NSEntityDescription.insertNewObject(forEntityName: "CurrentWeather", into: context) as? CurrentWeather {
            updateWeatherDataInCoreData(weather, updateWith: forecast)
            currentWeatherSet.append(weather)
            let thisIndexPath = IndexPath(row: currentWeatherSet.count - 1, section: 0)
            tableView.insertRows(at: [thisIndexPath], with: .fade)
            doTrySaveInContext()
        }
        
    }
    // update the weather data in the data base with data returned from the net service
    func updateWeatherDataInCoreData(_ weather: CurrentWeather, updateWith forecast: Forecast) {
        weather.cityID = Int64(forecast.cityID)
        weather.weatherDescription = forecast.weatherCondition[0].conditionDescription
        weather.cityName = forecast.cityName
        weather.time = Int64(forecast.time)
        weather.icon = forecast.weatherCondition[0].conditionIconCode
        weather.tempCelcius = forecast.temperatures.temperatureKelvin
        weather.maxTempCelcius = forecast.temperatures.tempMax
        weather.minTempCelcius = forecast.temperatures.tempMin
        weather.humidity = forecast.temperatures.humidity
        doTrySaveInContext()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return currentWeatherSet.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
          let weather = currentWeatherSet[indexPath.row]
          cell.configure(weather)
          return cell
    }
  
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete {
        appDelegate.persistentContainer.viewContext.delete(currentWeatherSet[indexPath.row])
             appDelegate.saveContext()
             fetchCoreData()
            }
    }
 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // pass data between CurrentWeatherTableViewController and SearchCityViewController
        if let searchViewController = segue.destination as? SearchCityViewController {
            searchViewController.delegate = self
        }
        // pass data from CurrentWeatherTableViewController to WeatherDetailsViewController
        if let weatherDetailsViewController = segue.destination as? WeatherDetailsViewController {
            weatherDetailsViewController.weather = currentWeatherSet[tableView.indexPathForSelectedRow!.row]
        }
    }
  
    func doTrySaveInContext() {
        let context = appDelegate.persistentContainer.viewContext
        do {
            try context.save()
        }
        catch let error {
            self.disPlayError(error.localizedDescription)
        }
    }
}

extension CityWeatherTableTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchController != nil {
            searchController!.dismiss(animated: true, completion: nil)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           fetchCoreData()
           self.tableView.reloadData()
        } else {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: CurrentWeather.self))
            fetchRequest.predicate = NSPredicate.init(format: "cityName CONTAINS[c] %@", searchText)
            do {
                let context = appDelegate.persistentContainer.viewContext
                self.currentWeatherSet = try context.fetch(fetchRequest) as! [CurrentWeather]
                 self.tableView.reloadData()
            } catch let error {
                self.disPlayError(error.localizedDescription)
            }
        }
    }
}
