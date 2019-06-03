//
//  SearchCityViewController.swift
//  CityWeather-3
//
//  Created by Yinhuan Yuan on 5/14/19.
//  Copyright © 2019 Jun Dang. All rights reserved.
//

import UIKit
import GooglePlaces

protocol SearchCityDelegate {
    func callAPIServiceAndUpdateUI(_ cityName: String)
}

import UIKit
import GooglePlaces

class SearchCityViewController: UIViewController {
    
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var delegate: SearchCityDelegate?
    let progressHUD = ProgressHUD(text: "adding data")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self as! GMSAutocompleteResultsViewControllerDelegate
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRect(x: 0, y: 65.0, width: 350.0, height: 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        progressHUD.backgroundColor = UIColor.black
        view.addSubview(progressHUD)
        progressHUD.hide()
    }
}

// Handle the user's selection.
extension SearchCityViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        progressHUD.show()
       // print("the method called")
        delegate?.callAPIServiceAndUpdateUI(place.name!)
        dismiss(animated: true, completion: nil)
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

