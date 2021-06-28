import UIKit
import SDWebImage
import Firebase
import FirebaseAuth
import FirebaseDatabase

class VerCargaViewController: UIViewController, CargaSendingDelegateProtocol {

    
    @IBOutlet weak var nombreLabelView: UILabel!
    @IBOutlet weak var cargaImageView: UIImageView!
    @IBOutlet weak var descripcionLabelView: UITextView!
    @IBOutlet weak var tipoLabelView: UILabel!
    @IBOutlet weak var pesoLabelView: UILabel!
    @IBOutlet weak var precioLabelView: UILabel!
    @IBOutlet weak var estadoLabelView: UILabel!
    @IBOutlet weak var ubInicioLabelView: UILabel!
    @IBOutlet weak var ubDestinoLabelView: UILabel!
 
    var carga = Carga()
    
    @IBAction func editTapped(_ sender: Any) {
        performSegue(withIdentifier: "updateCargaSegue", sender: carga)
     }
     
    @IBAction func verOfertasTapped(_ sender: Any) {
        performSegue(withIdentifier: "verOfertasSegue", sender: carga)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nombreLabelView.text = carga.nombre_carga
        cargaImageView.sd_setImage(with: URL(string: carga.imagen_url), completed: nil)
        descripcionLabelView.text = carga.descripcion_carga
        tipoLabelView.text = carga.tipo
        pesoLabelView.text = carga.peso
        estadoLabelView.text = carga.disponible ? "Disponible" : "No disponible"
        precioLabelView.text = String(carga.precio)
        ubInicioLabelView.text = carga.ubicacion_inicio
        ubDestinoLabelView.text = carga.ubicacion_destino
    }
    
    func sendDataToVerCargaViewController(miCarga: Carga) {
        nombreLabelView.text = miCarga.nombre_carga
        cargaImageView.sd_setImage(with: URL(string: miCarga.imagen_url), completed: nil)
        descripcionLabelView.text = miCarga.descripcion_carga
        tipoLabelView.text = miCarga.tipo
        pesoLabelView.text = miCarga.peso
        estadoLabelView.text = miCarga.disponible ? "Disponible" : "No disponible"
        precioLabelView.text = String(miCarga.precio)
        ubInicioLabelView.text = miCarga.ubicacion_inicio
        ubDestinoLabelView.text = miCarga.ubicacion_destino
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateCargaSegue" {
            let siguienteVC = segue.destination as! CargaUpdateViewController
            siguienteVC.carga = sender as! Carga
            siguienteVC.delegate = self
        } else if segue.identifier == "verOfertasSegue" {
            let siguienteVC = segue.destination as! OfertasCargaViewController
            siguienteVC.carga = sender as! Carga
        }
    }

}
