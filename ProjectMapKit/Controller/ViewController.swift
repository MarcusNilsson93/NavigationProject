//
//  ViewController.swift
//  ProjectMapKit
//
//  Created by Marcus Nilsson on 2020-02-26.
//  Copyright © 2020 Marcus Nilsson. All rights reserved.
//

import UIKit
import Mapbox
import MapKit
import MapboxCoreNavigation
import MapboxNavigation
import MapboxDirections

class ViewController: UIViewController, MGLMapViewDelegate,UISearchBarDelegate{
    
    var mapView: NavigationMapView!
    var directionRoute: Route?
    var PolyLineStyle: NSExpression!
    var resultSearchController: UISearchController? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //creates a MapView
        mapView = NavigationMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(CLLocationCoordinate2D(latitude: 59.31, longitude: 18.06), zoomLevel: 9, animated: false)
        
        view.addSubview(mapView)
        
        mapView.delegate = self
        
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true, completionHandler: nil)
        
        // adds longPress gesture on the map
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
        mapView.addGestureRecognizer(longPress)
    }
    //calculates the route
    func calculateRoute(from originCoor:CLLocationCoordinate2D, to destinationCoor: CLLocationCoordinate2D, completion: @escaping (Route?,Error?)-> Void){
        let orgin = Waypoint(coordinate: originCoor, coordinateAccuracy: -1, name: "Start")
        let destination = Waypoint(coordinate: destinationCoor, coordinateAccuracy: -1, name: "Finish")
        
        let options = NavigationRouteOptions(waypoints: [orgin,destination], profileIdentifier: .automobileAvoidingTraffic)
        
        _ = Directions.shared.calculate(options, completionHandler: { (waypoints, routes, error) in
            self.directionRoute = routes?.first
            
            // function call that draws a line between waypoints
            drawRoute(route: self.directionRoute!)
            
            let coordinateBounds = MGLCoordinateBounds(sw: destinationCoor, ne: originCoor)
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            let routeCam = self.mapView.cameraThatFitsCoordinateBounds(coordinateBounds,edgePadding: insets)
            self.mapView.setCamera(routeCam, animated: true)
        })
        //Function that draws the line on the map, and adjusts it
        func drawRoute(route: Route){
            guard route.coordinateCount > 0 else {return}
            var routeCoordinates = route.coordinates!
            let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
            
            if let source = mapView.style?.source(withIdentifier: "route-source") as? MGLShapeSource {
                source.shape = polyline
            }else{
                let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
                
                let lineStyle = MGLLineStyleLayer(identifier: "route-style", source: source)
                // Line propertys
                lineStyle.lineColor = NSExpression(forConstantValue: UIColor.systemBlue)
                lineStyle.lineWidth = NSExpression(forConstantValue: 3.0)
                
                mapView.style?.addSource(source)
                mapView.style?.addLayer(lineStyle)
            }
        }
    }
    // Function gets called when holding down a finger on the screen
    @objc func didLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        
        // Converts point where user did a long press to map coordinates
        let point = sender.location(in: mapView)
        let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
        
        // Create a basic point annotation and add it to the map
        let annotation = MGLPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Start navigation"
        mapView.addAnnotation(annotation)
        calculateRoute(from: (mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
            if error != nil {
                print("Error calculating route")
            }
        }
    }
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    //Presents the navigation VC after pressing Start Navigation
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationVC = NavigationViewController(for: directionRoute!)
        present(navigationVC, animated: true, completion: nil)
    }
    @IBAction func searchBtn(_ sender: Any) {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        mapView.setUserTrackingMode(.none, animated: true, completionHandler: nil)
        var interactions = UIView.accessibilityRespondsToUserInteraction()
        interactions = false
        if interactions == false {
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.color = (UIColor .gray)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            
            self.view.addSubview(activityIndicator)
            
            //Hide searchBar
            searchBar.resignFirstResponder()
            dismiss(animated: true, completion: nil)
            
            //creates the searchRequest
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = searchBar.text
            
            let activitySearch = MKLocalSearch(request: request)
            
            activitySearch.start { (response, error) in
                
                //Allows user to interact with map again and removes the activityIndicator
                interactions = true
                activityIndicator.stopAnimating()
                
                if error != nil{
                    //Error handeling
                }
                else{
                    print(response ?? "Somting went wrong")
                    
                    //Removing old annotations if there is any
                    if self.mapView.annotations != nil {
                        let anotations = self.mapView.annotations
                        self.mapView.removeAnnotations(anotations!)
                    }
                    
                    // Getting Data
                    let latitude = response?.boundingRegion.center.latitude
                    let longitude = response?.boundingRegion.center.longitude
                    
                    //Creating annotation on the map at the searched location
                    let annotation = MGLPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
                    annotation.title = "Start navigation"
                    self.mapView.addAnnotation(annotation)
                    self.calculateRoute(from: (self.mapView.userLocation!.coordinate), to: annotation.coordinate) { (route, error) in
                        if error != nil {
                            print("Error calculating route")
                        }
                    }
                }
            }
        }
    }
}
