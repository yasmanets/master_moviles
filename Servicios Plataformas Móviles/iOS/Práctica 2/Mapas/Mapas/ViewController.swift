//
//  ViewController.swift
//  Mapas
//
//  Created by Yaser  on 21/2/21.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    private var pinNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.segmentControl.setTitle("Mapa", forSegmentAt: 0)
        self.segmentControl.setTitle("Satélite", forSegmentAt: 1)
        let userTrackingButton = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.leftBarButtonItem = userTrackingButton
    }
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .standard
            mapView.delegate = self
            let alicanteLocation = CLLocationCoordinate2D(latitude: 38.3453, longitude: -0.4831)
            centerMapOnLocation(mapView: mapView, loc: alicanteLocation)
        }
    }
    
    func centerMapOnLocation(mapView: MKMapView, loc: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 4000
        let coordinateRegion = MKCoordinateRegion(center: loc,
                                                  latitudinalMeters: regionRadius,
                                                  longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func segmentControlSelection(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 1) {
            mapView.mapType = MKMapType.satellite
        }
        else {
            mapView.mapType = MKMapType.standard
        }
    }
    
    @IBAction func addAnnotation(_ sender: UIBarButtonItem) {
        self.pinNum += 1
        getLocationCountry(location2D: mapView.centerCoordinate) { country, error in
            if !country.isEmpty {
                let pin = Pin(num: self.pinNum, subtitle: country, coordinate: self.mapView.centerCoordinate)
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: Pin.self) {
            let pin = annotation as? Pin
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)

            view.pinTintColor = UIColor.red
            view.animatesDrop = true
            view.canShowCallout = true
            let thumbnailImageView = UIImageView(frame: CGRect(x:0, y:0, width: 59, height: 59))
            thumbnailImageView.image = pin?.thumbImage
            view.leftCalloutAccessoryView = thumbnailImageView
            view.rightCalloutAccessoryView = UIButton(type:UIButton.ButtonType.detailDisclosure)
            return view
        }
        return nil;
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            performSegue(withIdentifier: "DetalleImagen", sender: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetalleImagen" {
                if let annotationView = sender as? MKAnnotationView {
                    let selectedAnnotation = annotationView.annotation
                    let detailController = segue.destination as! DetalleImagenViewController
                    detailController.annotationTitle = selectedAnnotation?.title ?? ""
                }
            }
    }
    
    func getLocationCountry (location2D: CLLocationCoordinate2D, completionHandler: @escaping(String, NSError?) -> Void) {
        let location = CLLocation(latitude: location2D.latitude, longitude: location2D.longitude)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    completionHandler(placemark.country!, nil)
                    return
                }
            }
            completionHandler("Error", error as NSError?)
        })
    }
}

