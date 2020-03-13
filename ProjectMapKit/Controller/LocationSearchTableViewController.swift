//
//  LocationSearchTableViewController.swift
//  ProjectMapKit
//
//  Created by Marcus Nilsson on 2020-03-01.
//  Copyright © 2020 Marcus Nilsson. All rights reserved.
//

import UIKit
import MapKit
import MapboxNavigation
import CoreLocation

class LocationSearchTableViewController: UITableViewController, MGLMapViewDelegate {
    
    var matchingItems: [MKMapItem] = []
    var mapView: NavigationMapView!
    var locationManager = CLLocationManager()
    var currant: CLLocationCoordinate2D!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ViewDid")
        
        
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    /*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }*/

   

}
extension LocationSearchTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //var Location = mapView?.userLocation?.coordinate
        
        guard let _ = mapView, let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        print(searchBarText)
        let region = MKCoordinateRegion(center: currant, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, _) in
            guard let response = response else {return}
            print("Searching....")
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
        
        //request.region = mapView.region
        //mapView.localizeLabels()
        
    }
}
extension LocationSearchTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
//Fixa API SEARCH
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = ""
        return cell
    }
}


