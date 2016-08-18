//
//  ThirthMenuViewController.swift
//  settingsMyTests
//
//  Created by Zacharias Giakoumi on 10/08/16.
//  Copyright © 2016 Zacharias Giakoumi. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import CoreLocation

class ThirthMenuViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
     var locationManager = CLLocationManager()
    
    
    @IBAction func refreshlocationAction(sender: AnyObject) {
        self.locationManager.startUpdatingLocation()
        self.view.makeToastActivity(message: "Location..")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setNavigationBarItem()
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.title =  "User Location"
        
        if (CLLocationManager.locationServicesEnabled()) {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            
            self.locationManager.startUpdatingLocation()
            self.view.makeToastActivity(message: "Location")
        }
        
       
        
        
        
        
        // Do any additional setup after loading the view.
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
    
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        self.mapView.setRegion(region, animated: true)
        
        
        // Add an annotation on Map View
        let point: MKPointAnnotation! = MKPointAnnotation()
        
        point.coordinate = location!.coordinate
        point.title = "This is your location"
        point.subtitle = "hi there"
        
        self.mapView.addAnnotation(point)
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        self.view.hideToastActivity()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
