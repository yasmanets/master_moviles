//
//  ViewController.swift
//  MapLocation
//
//  Created by Yaser  on 25/4/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    private let locationManager = CLLocationManager()
    private var locationsHistory: [CLLocation] = []
    private var totalMovementDistance = CLLocationDistance(0)
    
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var horizontalAccuracyLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var verticalAccuracyLabel: UILabel!
    @IBOutlet weak var distanceTraveledLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapView.mapType = .hybrid
        mapView.userTrackingMode = .follow
        mapView.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Authorization status changed to \(status.rawValue)")
        switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.startUpdatingLocation()
                print("Emapezamos a sondear la ubicación")
                mapView.showsUserLocation = true
            default:
                locationManager.stopUpdatingLocation()
                print("Paramos el sondeo de la ubicación")
                mapView.showsUserLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let alertController = UIAlertController(title: "Location Manager Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
        }
        for newLocation in locations {
            if newLocation.horizontalAccuracy < 100 && newLocation.horizontalAccuracy >= 0 && newLocation.verticalAccuracy < 50 {
                let latitudeString = String(format: "%gº", newLocation.coordinate.latitude)
                latitudeLabel.text = latitudeString
                let longitudeString = String(format: "%gº", newLocation.coordinate.longitude)
                longitudeLabel.text = longitudeString
                let horizontalAccuracyString = String(format:"%gm", newLocation.horizontalAccuracy)
                horizontalAccuracyLabel.text = horizontalAccuracyString
                let altitudeString = String(format:"%gm", newLocation.altitude)
                altitudeLabel.text = altitudeString
                let verticalAccuracyString = String(format:"%gm", newLocation.verticalAccuracy)
                verticalAccuracyLabel.text = verticalAccuracyString
                if let previousPoint = locationsHistory.last {
                    print("movement distance: " + "\(newLocation.distance(from: previousPoint))")
                    totalMovementDistance += newLocation.distance(from: previousPoint)
                    var area = [previousPoint.coordinate, newLocation.coordinate]
                    let polyline = MKPolyline(coordinates: &area, count: area.count)
                    mapView.addOverlay(polyline)
                }
                else {
                    let start = Place(title: "Inicio", subtitle: "Este es el punto de inicio de la ruta", coordinate: newLocation.coordinate)
                    mapView.addAnnotation(start)
                }
                self.locationsHistory.append(newLocation)
                let distanceString = String(format:"%gm", totalMovementDistance)
                distanceTraveledLabel.text = distanceString
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.red
            pr.lineWidth = 5
            return pr
        }
        else {
            return MKPolylineRenderer(overlay: overlay)
        }
    }


}

