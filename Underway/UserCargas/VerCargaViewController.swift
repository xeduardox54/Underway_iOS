import UIKit
import SDWebImage

class VerCargaViewController: UIViewController {

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
        print(carga)
        performSegue(withIdentifier: "updateCargaSegue", sender: carga)
     }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "updateCargaSegue" {
            let siguienteVC = segue.destination as! CargaUpdateViewController
            siguienteVC.carga = sender as! Carga
        }
    }

}
