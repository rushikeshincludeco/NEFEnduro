//
//  MapViewController.swift
//  
//
//  Created by include tech. on 27/12/16.
//
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import SnapKit
import Alamofire
import TransitionTreasury
import TransitionAnimation

class MapViewController: UIViewController, CLLocationManagerDelegate, XMLParserDelegate, GMSMapViewDelegate , NavgationTransitionable {
    
    var mapView = GMSMapView()
    var locationManager : CLLocationManager!
    var boundaries = [CLLocationCoordinate2D]()
    var tr_pushTransition: TRNavgationTransitionDelegate?

    var annotations : [Station] = []
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    let apiKey = "AIzaSyDGvYxVA7Siozy0-WSgiR6PKyV3i0OciOs"
    let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(view.snp.height).multipliedBy(0.8)
        }
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.addTarget(self, action: #selector(MapViewController.backButtonPressed), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(mapView)
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        determineCurrentLocation()
        
        mapView.center = view.center
        
        annotations = getMapAnnotations()
        
        for annotation in annotations {
            points.append(annotation.coordinate)
        }
    }
    
    func backButtonPressed(){
         navigationController?.popViewController(animated: true)
    }
    
    
    func drawPolyline(station : Station, isOnPath : Bool) {
        let route = GMSMutablePath()
        let inCompleteRoute = GMSMutablePath()
        var indexOfArray : Int = 0
        if points.count > 0 {
            for waypoint in points {
                let lat: Double = (waypoint.latitude)
                let lng: Double = (waypoint.longitude)
                route.add(CLLocationCoordinate2D(latitude: lat, longitude: lng))
            }
        }
        let path: GMSPath = GMSPath(path: route)
        let routePolyline = GMSPolyline(path: path)
        if isOnPath == true {
            routePolyline.strokeColor = UIColor.blue
        }else {
            routePolyline.strokeColor = UIColor.green
        }
        routePolyline.strokeWidth = 3
        routePolyline.map = self.mapView
        
        for (i,point) in points.enumerated() {
            if point.latitude == station.latitude && point.longitude == station.longitude {
                indexOfArray = i
                break
            }
        }
        for j in indexOfArray...points.count-1{
            inCompleteRoute.add(CLLocationCoordinate2D(latitude: points[j].latitude, longitude: points[j].longitude))
        }
        if isOnPath == true {
        let inCompletepath: GMSPath = GMSPath(path: inCompleteRoute)
        let inCompleteroutePolyline = GMSPolyline(path: inCompletepath)
        inCompleteroutePolyline.strokeColor = UIColor.red
       
        inCompleteroutePolyline.strokeWidth = 3
        inCompleteroutePolyline.map = self.mapView
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func determineCurrentLocation()
    {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 100.0 // Will notify the LocationManager every 100 meters
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        manager.delegate = nil
        if let userLocation:CLLocation = locations.last {
            let camera = GMSCameraPosition.camera(withTarget: (CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)), zoom: 15)
            mapView.isMyLocationEnabled = true
            mapView.camera = camera
            
            let curLocation = Station(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let destLocation = Station(latitude: (points.first?.latitude)!, longitude: (points.first?.longitude)!)
            
            let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(curLocation.latitude.description),\(curLocation.longitude)&destination=\(destLocation.latitude),\(destLocation.longitude)&alternatives=false&key=\(apiKey)"
            
            Alamofire.request(directionURL, method: .get, parameters: [:], encoding: URLEncoding.default, headers: nil).responseJSON { response  in
                
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value {
                        
                        let details = data
                        
                        if let json = details as? NSDictionary {
                            if json["error"] != nil {
                                
                            } else {
                                if let routes = json.value(forKey: "routes")  {
                                    
                                    if let overview = (routes as AnyObject).value(forKey: "overview_polyline")//["overview_polyline"] as? NSDictionary
                                    {
                                        let overViewPolyLine = (overview as AnyObject).value(forKey:"points")
                                        if overViewPolyLine != nil {
                                            let smarker = GMSMarker()
                                            smarker.position = CLLocationCoordinate2D(latitude: (self.annotations.first?.coordinate.latitude)!, longitude: (self.annotations.first?.coordinate.longitude)!)
                                            smarker.title = "Starting Point"
                                            smarker.map = self.mapView
                                            
                                            let dmarker = GMSMarker()
                                            dmarker.position = CLLocationCoordinate2D(latitude: (self.annotations.last?.coordinate.latitude)!, longitude: (self.annotations.last?.coordinate.longitude)!)
                                            dmarker.title = "Finishing Point"
                                            dmarker.map = self.mapView
                                            
                                            
                                            let cmarker = GMSMarker()
                                            cmarker.position = CLLocationCoordinate2D(latitude: curLocation.latitude, longitude: curLocation.longitude)
                                            cmarker.title = "Current Location"
                                            cmarker.map = self.mapView
                                            
                                            for route in routes as! NSArray {
                                                if let route = route as? [String:AnyObject] {
                                                    let routeOverviewPolyline = route["overview_polyline"]
                                                    let points = routeOverviewPolyline?["points"]
                                                    let path = GMSPath.init(fromEncodedPath: points as! String)
                                                    let polyline = GMSPolyline.init(path: path)
                                                    polyline.strokeColor = UIColor.red
                                                    if routeOverviewPolyline?.contains(curLocation) == true {
                                                        self.drawPolyline(station: curLocation, isOnPath: true)
                                                    } else {
                                                        self.drawPolyline(station: curLocation, isOnPath: false)
                                                    }
                                                    polyline.strokeWidth = 5
                                                    polyline.map = self.mapView
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    self.locationManager.stopUpdatingLocation()
                    break
                    
                case .failure(_):
                    
                    print(response.result.error!)
                    break
                }
            }
        }
    }
    
    func getMapAnnotations() -> [Station] {
        var annotations:Array = [Station]()
        let fileName = "path"
        
        let filePath = getFilePath(fileName: fileName)
        let data =  NSData(contentsOf: NSURL(fileURLWithPath: filePath!) as URL)
        
        let parser = XMLParser(data: data! as Data)
        parser.delegate = self
        
        let success = parser.parse()
        
        if !success {
            print ("Failed to parse the following file: path.gpx")
        }
        
        if boundaries.count > 0 {
            for index in 0...boundaries.count-1 {
                let lat = boundaries[index].latitude
                let long = boundaries[index].longitude
                let annotation = Station(latitude: lat, longitude: long)
                annotations.append(annotation)
            }
        }
        return annotations
    }
    
    @objc func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        if elementName == "trkpt" || elementName == "wpt" {
            let lat = attributeDict["lat"]!
            let lon = attributeDict["lon"]!
            boundaries.append(CLLocationCoordinate2DMake(CLLocationDegrees(lat)!, CLLocationDegrees(lon)!))
        }
    }
    
    func getFilePath(fileName: String) -> String? {
        return Bundle.main.path(forResource: fileName, ofType: "gpx")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

class Station: NSObject, MKAnnotation {
	var title: String?
	var subtitle: String?
	var latitude: Double
	var longitude:Double
 
	var coordinate: CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
	}
 
	init(latitude: Double, longitude: Double) {
		self.latitude = latitude
		self.longitude = longitude
	}
}
