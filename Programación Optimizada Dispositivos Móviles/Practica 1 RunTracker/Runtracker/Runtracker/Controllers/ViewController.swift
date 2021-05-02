//
//  ViewController.swift
//  Runtracker
//
//  Created by Yaser  on 25/4/21.
//

import UIKit
import CoreLocation
import CoreMotion
import MapKit
import AVFoundation

private enum TrainingStatus {
    case Started
    case Paused
    case Stopped
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var chronometerLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rhythmLabel: UILabel!
    @IBOutlet weak var cadenceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var actionButton: UIButton!
    private var trainingStatus: TrainingStatus = .Stopped
    private let userDefauls = UserDefaults()
    
    // Timer
    var timer: Timer = Timer()
    var count: Int = 0
    var isCounting: Bool = false
    
    // Location
    private let locationManager = CLLocationManager()
    private var locationsHistory: [CLLocation] = []
    private var totalDistance = CLLocationDistance(0)
    
    // Pedometer
    private let pedometer = CMPedometer()
    private let motionActivityManager = CMMotionActivityManager()
    private var activity = ""
    private var trainings: [Train] = []
    
    // Sound
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressed(_:)))
        self.actionButton.isUserInteractionEnabled = true
        self.actionButton.addGestureRecognizer(longPress)
        
        self.setCLLocationManager()
        self.setMapViewProperties()
    }
    
    // MARK: - Manage Training
    func requestPermissions() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            startTraining()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            self.actionButton.isEnabled = false
        }
    }
    
    func startTraining() {
        if (self.isPedometerAvailable() && self.isMotionActivityAvailable()) {
            self.trainingStatus = .Started
            self.actionButton.setImage(UIImage(named: "pause.png"), for: .normal)
            self.isCounting = true
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCounter), userInfo: nil, repeats: true)
            mapView.showsUserLocation = true
            self.startPedotemer()
            self.startMotionActivity()
        }
    }
    
    func pauseTraining() {
        self.trainingStatus = .Paused
        self.actionButton.setImage(UIImage(named: "play.png"), for: .normal)
        self.isCounting = false
        self.timer.invalidate()
        self.pauseOrStopPedometer()
        self.stopMotionActivity()
    }
    
    func stopTraining() {
        self.trainingStatus = .Stopped
        self.actionButton.setImage(UIImage(named: "play.png"), for: .normal)
        self.count = 0
        self.timer.invalidate()
        self.saveTraining()
        self.chronometerLabel.text = TimeManagement.timeToString(hours: 0, minutes: 0, seconds: 0)
        self.pauseOrStopPedometer()
        self.stopMotionActivity()
        
    }
    
    func saveTraining() {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        if let trainingsData = userDefauls.object(forKey: "trainings") as? Data {
            if let storedTrainings = try? decoder.decode([Train].self, from: trainingsData) {
                self.trainings = storedTrainings
            }
            let train = Train(date: dateFormatter.string(from: Date()), distance: self.distanceLabel.text!, time: self.chronometerLabel.text!)
            trainings.append(train)
            if let encoded = try? encoder.encode(self.trainings) {
                self.userDefauls.set(encoded, forKey: "trainings")
                self.userDefauls.synchronize()
            }
        }
        else {
            let train = Train(date: dateFormatter.string(from: Date()), distance: self.distanceLabel.text!, time: self.chronometerLabel.text!)
            trainings.append(train)
            if let encoded = try? encoder.encode(self.trainings) {
                self.userDefauls.set(encoded, forKey: "trainings")
                self.userDefauls.synchronize()
            }
        }
    }
    
    // MARK: - Process time counting
    @objc func timeCounter() -> Void {
        self.count = self.count + 1
        let time = TimeManagement.countToTime(seconds: self.count)
        let timeString = TimeManagement.timeToString(hours: time.0, minutes: time.1, seconds: time.2)
        self.chronometerLabel.text = timeString
    }
    
    // MARK: - MapView properties
    func setMapViewProperties() {
        self.mapView.mapType = .hybrid
        self.mapView.userTrackingMode = .followWithHeading
        self.mapView.delegate = self
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
    
    //MARK: - CLLocationManager
    func setCLLocationManager() {
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        let gpsConfig = userDefauls.string(forKey: "gps")
        switch gpsConfig {
        case "optimal":
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        case "medium":
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        case "low":
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        default:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.stopUpdatingLocation()
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
                if let previousPoint = locationsHistory.last {
                    self.totalDistance += newLocation.distance(from: previousPoint)
                    var area = [previousPoint.coordinate, newLocation.coordinate]
                    let polyline = MKPolyline(coordinates: &area, count: area.count)
                    self.mapView.addOverlay(polyline)
                }
                else {
                    let start = Place(title: "Inicio", subtitle: "Este es el punto de inicio de la ruta", coordinate: newLocation.coordinate)
                    mapView.addAnnotation(start)
                }
                self.locationsHistory.append(newLocation)
                self.distanceLabel.text = DistanceManagement.metersToKilometers(meters: totalDistance)
            }
        }
    }
    
    // MARK: - Pedometer functions
    func isPedometerAvailable() -> Bool {
        if CMPedometer.isStepCountingAvailable() {
            return true
        }
        else {
            let alert = UIAlertController(title: "Error", message: "El podómetro no está disponible", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            self.actionButton.isEnabled = false
            return false
        }
    }
    
    func startPedotemer() {
        self.pedometer.startUpdates(from: Date()) { (data, error) in
            DispatchQueue.main.async {
                let cadence = data?.currentCadence ?? 0
                let pace = data?.currentPace ?? 0
                self.cadenceLabel.text = DistanceManagement.stepsPerMinute(cadence: cadence)
                self.rhythmLabel.text = DistanceManagement.pacePerMinute(pace: pace)
                self.checkNotificationOptions(cadence: (cadence as! Int * 60), distance: self.totalDistance)
            }
        }
    }
    
    func pauseOrStopPedometer() {
        self.pedometer.stopUpdates()
        if self.trainingStatus == .Stopped {
            self.cadenceLabel.text = "00.00"
            self.rhythmLabel.text = "00.00"
        }
    }
    
    // MARK: - MotionActivityManager
    func isMotionActivityAvailable() -> Bool {
        if CMMotionActivityManager.isActivityAvailable() {
            return true
        }
        else {
            let alert = UIAlertController(title: "Error", message: "El MotionActivityManager no está disponible", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            self.actionButton.isEnabled = false
            return false
        }
    }
    
    func startMotionActivity () {
        self.motionActivityManager.startActivityUpdates(to: OperationQueue.main) { (motion) in
            if (motion?.stationary)! {
                let isAutopause = self.userDefauls.bool(forKey: "autopause")
                if isAutopause && self.trainingStatus == .Started {
                    self.stopTraining()
                }
            }
            else if (motion?.walking)! {
                self.activity = "Caminando"
            }
            else if (motion?.running)! {
                self.activity = "Corriendo"
            }
            else if (motion?.cycling)! {
                self.activity = "En bici"
            }
            else {
                self.activity = "No se ha podido definir"
            }
        }
    }
    
    func stopMotionActivity () {
        self.motionActivityManager.stopActivityUpdates()
    }

    // MARK: - Button actions
    @IBAction func singleTap(_ sender: Any) {
        switch self.trainingStatus {
        case .Started:
            self.pauseTraining()
        case .Paused:
            self.requestPermissions()
        case .Stopped:
            self.requestPermissions()
        }
    }
    
    @objc func onLongPressed(_ sender: UILongPressGestureRecognizer) {
        if self.trainingStatus != .Stopped {
            self.stopTraining()
        }
    }
    
    // MARK: - Notification
    func checkNotificationOptions(cadence: Int, distance: Double) {
        let savedCadence = self.userDefauls.integer(forKey: "cadence")
        if (savedCadence != 0 && cadence < savedCadence) {
            self.displaySoundNotification(title: "Cadencia", message: "Tu cadencia es menor que la que tienes configurada!")
        }
        
        let intervalValue = self.userDefauls.integer(forKey: "intervalValue")
        if intervalValue != 0 {
            let intervalKey = self.userDefauls.string(forKey: "intervalKey")
            switch intervalKey {
            case "time":
                let currenTime = TimeManagement.countToTime(seconds: self.count)
                if (currenTime.1 == intervalValue) {
                    self.displaySoundNotification(title: "Tiempo", message: "Has alcanzado los \(intervalValue) minutos que has configurado!")
                }
            case "distance":
                let meters = Int(distance)
                if (meters == intervalValue) {
                    self.displaySoundNotification(title: "Distancia", message: "Has llegado a alcanzar \(meters) metros!")
                }
            default:
                break
            }
        }

    }
    func displaySoundNotification(title: String, message: String) {
        let path = Bundle.main.path(forResource: "alert.wav", ofType: nil)!
        let url = URL(fileURLWithPath: path)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.audioPlayer?.stop()
        }
        alert.addAction(okAction)
        
        self.audioPlayer = try? AVAudioPlayer(contentsOf: url)
        self.audioPlayer?.volume = 1.0
        self.audioPlayer?.numberOfLoops = 10
        self.audioPlayer?.play()
        present(alert, animated: true, completion: nil)
    }
}

