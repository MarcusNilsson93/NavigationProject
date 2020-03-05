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

class LocationSearchTableViewController: UITableViewController, MGLMapViewDelegate {

    var matchingItems: [MKMapItem] = []
    var mapView: NavigationMapView?  = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

   

}
extension LocationSearchTableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let mapView = mapView, let searchBarText = searchController.searchBar.text else {return}
        let request = MKLocalSearch.Request()
        //let coor = MKCoordinateRegion()
        
        
        request.naturalLanguageQuery = searchBarText
        //request.region
        mapView.localizeLabels()
        
    }
}

