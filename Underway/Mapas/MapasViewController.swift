
import UIKit
import MapKit
class MapasViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var ubicacion = CLLocationManager()
    
    
    var contActualizaciones = 0
    @IBAction func centrarTapped(_ sender: Any) {
        print("Brujula")
        if let coord = ubicacion.location?.coordinate{
            let region = MKCoordinateRegion.init(center: coord, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            contActualizaciones += 1
        }
    }
    
    @IBOutlet weak var centrarTapped: UIButton!
    @IBOutlet weak var btncentrarTapped: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicacion.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
            ubicacion.startUpdatingLocation()
        }else{
            ubicacion.requestWhenInUseAuthorization()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if contActualizaciones < 1 {
            
            let region = MKCoordinateRegion.init(center: ubicacion.location!.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
            
            
            contActualizaciones += 1
        
        }else{
            self.ubicacion.stopUpdatingLocation()
        }
        
    }
    
}

