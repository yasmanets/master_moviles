//
//  ScanViewController.swift
//  beacons
//
//  Created by Yaser  on 10/5/21.
//

import UIKit
import CoreLocation

class ScanViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var uuidText: UITextField!
    @IBOutlet weak var majorText: UITextField!
    @IBOutlet weak var minorText: UITextField!
    @IBOutlet weak var identityText: UITextField!
    
    var beaconsToRange: [CLBeacon] = []
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.locationManager = CLLocationManager.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.rowHeight = 100
    }
}

// MARK: - Table View Controller
extension ScanViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.beaconsToRange.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "beaconCell", for: indexPath) as! BeaconTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        cell.identity.text = "\(self.beaconsToRange[indexPath.row].uuid)"
        cell.timestamp.text = dateFormatter.string(from: self.beaconsToRange[indexPath.row].timestamp)
        cell.signal.text = String(self.beaconsToRange[indexPath.row].rssi)
        switch self.beaconsToRange[indexPath.row].proximity {
        case .unknown:
            cell.distance.text = "Desconocida"
            self.view.backgroundColor = UIColor.gray
        case .far:
            cell.distance.text = "Lejana"
            cell.backgroundColor = UIColor.blue
        case .near:
            cell.distance.text = "Cercana"
            cell.backgroundColor = UIColor.orange
        case .immediate:
            cell.distance.text = "Intermedia"
            cell.backgroundColor = UIColor.red
        @unknown default:
            print("Error")
        }
        cell.accuracy.text = String(format: "%.2f", self.beaconsToRange[indexPath.row].accuracy)
        return cell
    }
}

extension ScanViewController: UITableViewDelegate {}

extension ScanViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    func startScanning() {
        let proximityUUID = UUID(uuidString: self.uuidText.text!)!
        let major : CLBeaconMajorValue = CLBeaconMajorValue.init((self.majorText.text as NSString?)!.floatValue)
        let minor : CLBeaconMinorValue = CLBeaconMinorValue.init((self.minorText.text as NSString?)!.floatValue)
        let regionID = self.identityText.text!
        
        let region = CLBeaconRegion (uuid: proximityUUID, major: major, minor: minor, identifier: regionID)
        region.notifyEntryStateOnDisplay = true
        self.locationManager.startMonitoring(for: region)
        self.locationManager.startRangingBeacons(in: region)
        print("Empezamos a monitorizar región")
    }
    
    func stopScanning() {
        let proximityUUID = UUID(uuidString: self.uuidText.text!)!
        let major : CLBeaconMajorValue = CLBeaconMajorValue.init((self.majorText.text as NSString?)!.floatValue)
        let minor : CLBeaconMinorValue = CLBeaconMinorValue.init((self.minorText.text as NSString?)!.floatValue)
        let regionID = self.identityText.text!
        
        let region = CLBeaconRegion (uuid: proximityUUID, major: major, minor: minor, identifier: regionID)
        self.locationManager.stopMonitoring(for: region)
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLBeaconRegion {
            // Empezamos a detectar la proximidad.
            if CLLocationManager.isRangingAvailable() {
                manager.startRangingBeacons(in: region as! CLBeaconRegion)
                print("Empezamos a sondear proximidad")

            }
        }
    }
        
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLBeaconRegion {
            // Detenemos la detección de proximidad.
            if CLLocationManager.isRangingAvailable() {
                manager.stopRangingBeacons(in: region as! CLBeaconRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            self.beaconsToRange.append(beacons.first!)
            self.tableView.reloadData()
        } else {
            print("desconocido")
        }
 
    }
}
