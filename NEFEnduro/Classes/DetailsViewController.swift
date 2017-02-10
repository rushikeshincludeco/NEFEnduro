//
//  DetailsViewController.swift
//  NEFEnduro
//
//  Created by Include tech. on 08/02/17.
//  Copyright © 2017 Include tech. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import GoogleMaps
import SnapKit
import Alamofire
import TransitionTreasury
import TransitionAnimation

class DetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NavgationTransitionable, CLLocationManagerDelegate, XMLParserDelegate, GMSMapViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var finalResult : [String : AnyObject] = [:]
    let labelText = UILabel()
    let labelDesc = UILabel()
    let labelSummary = UILabel()
    var mapView = GMSMapView()
    var locationManager : CLLocationManager!
    var boundaries = [CLLocationCoordinate2D]()
    
    var annotations : [Station] = []
    var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
    let apiKey = "AIzaSyDGvYxVA7Siozy0-WSgiR6PKyV3i0OciOs"
    var tr_pushTransition: TRNavgationTransitionDelegate?


    override func viewDidLoad() {
        

        
        super.viewDidLoad()
        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        view.addSubview(containerView)
        containerView.snp.makeConstraints{(make) in
            make.left.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.65)
        }
        
        let imageView = UIImageView()
        containerView.insertSubview(imageView, at: 0)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = containerView.frame
        imageView.clipsToBounds = true
        var image = UIImage()
        image = UIImage(named: "bgImage")!
        imageView.image = image
        imageView.snp.makeConstraints{ (make) in
            make.left.right.top.bottom.equalTo(containerView)
        }
        
        labelText.font = UIFont(name: "ALoveofThunder", size: 18)
        labelText.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelText.numberOfLines = 0
        containerView.addSubview(labelText)
        labelText.snp.makeConstraints { (make) in
            make.centerX.equalTo(containerView)
            make.height.equalTo(40)
            make.top.equalTo(containerView.snp.top).offset(65)
        }
        
        labelDesc.font = UIFont(name: "Roboto-Black", size: 15)
        labelDesc.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelDesc.numberOfLines = 0
        containerView.addSubview(labelDesc)
        labelDesc.snp.makeConstraints { (make) in
            make.left.right.equalTo(containerView).offset(5)
            make.height.equalTo(100)
            make.top.equalTo(labelText.snp.bottom)
        }
        
        labelSummary.font = UIFont(name: "Roboto-Black", size: 15)
        labelSummary.lineBreakMode = NSLineBreakMode.byWordWrapping
        labelSummary.numberOfLines = 0
        containerView.addSubview(labelSummary)
        labelSummary.snp.makeConstraints { (make) in
            make.left.equalTo(containerView).offset(5)
            make.height.equalTo(60)
            make.top.equalTo(labelDesc.snp.bottom)
        }
  
        tableView.delegate = self
        tableView.dataSource = self
        tableView.alwaysBounceVertical = false
        self.tableView.estimatedRowHeight = 100.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(containerView.snp.bottom)
        }

        labelText.text = finalResult["name"] as? String
        let str = finalResult["desc"] as? String
        labelDesc.text = str?.replacingOccurrences(of: ". ", with: ".\n")
        labelSummary.text = finalResult["summary"] as? String
        
        containerView.addSubview(mapView)
        mapView.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(containerView).offset(10)
            make.right.equalTo(containerView).offset(-10)
            make.top.equalTo(labelSummary.snp.bottom).offset(10)
            make.bottom.equalTo(tableView.snp.top).offset(-10)//.multipliedBy(0.4)
        }
        
        determineCurrentLocation()
        
        mapView.center = view.center
        
        annotations = getMapAnnotations()
        
        for annotation in annotations {
            points.append(annotation.coordinate)
        }
        
        let btn1 = UIButton(type: .custom)
        btn1.setTitle("Back", for: .normal)
        btn1.setTitleColor(UIColor.black, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 50, height: 30)
        btn1.addTarget(self, action: #selector(DetailsViewController.backButtonPressed), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setLeftBarButtonItems([item1], animated: true)

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

    
    func backButtonPressed(){
        
        _ = navigationController?.tr_popViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        if indexPath.section == 0 {
            cell.textLabel?.text = finalResult["fees"] as? String
        } else {
            let prize = finalResult["prize"] as! [String]
            let str = prize[indexPath.row]
         
            cell.textLabel?.text =  "\(indexPath.row + 1) : ".appending(str)
        }
        cell.textLabel?.numberOfLines = 0;
        cell.textLabel?.lineBreakMode = .byWordWrapping;


        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        
        if (section == 0){
            return "Registration Fees"
        }
        if (section == 1){
            return "Prize"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

