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

class MapViewController: UIViewController, CLLocationManagerDelegate, XMLParserDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager : CLLocationManager!
    var boundaries = [CLLocationCoordinate2D]()
    var annotations : [Station] = []
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    let apiKey = "AIzaSyDGvYxVA7Siozy0-WSgiR6PKyV3i0OciOs"
    let backButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.dismiss(animated: true, completion: nil)
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
        for var j in indexOfArray...points.count-1{
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
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingHeading()
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation:CLLocation = locations.last {
            let camera = GMSCameraPosition.camera(withTarget: (CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)), zoom: 15)
            mapView.isMyLocationEnabled = true
            mapView.camera = camera
            
            let curLocation = Station(latitude: 18.55217, longitude: 73.826589999999996)
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
                                if let routes : [String: AnyObject] = json["routes"] as? [String: AnyObject]{
                                    
                                    if let overview = routes["overview_polyline"] {
                                        let overViewPolyLine = overview["points"]
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
                                            
                                            for route in routes as! [AnyObject] {
                                                let routeOverviewPolyline = route["overview_polyline"]
                                                let points = routeOverviewPolyline?["points"]
                                                let path = GMSPath.init(fromEncodedPath: points as! String)
                                                let polyline = GMSPolyline.init(path: path)
                                                polyline.strokeColor = UIColor.redColor()
                                                if routeOverviewPolyline?.containsObject(curLocation) == true {
                                                    self.drawPolyline(curLocation, isOnPath: true)
                                                } else {
                                                    self.drawPolyline(curLocation, isOnPath: false)
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
                annota
                tions.append(annotation)
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
