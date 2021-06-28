
import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase

class DetallesCargaViewController: UIViewController {
    
    var carga: Carga?

    @IBOutlet weak var imagen_carga: UIImageView!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblRuta: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBAction func OfertarTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Realizar Oferta", message: "Ingrese el precio que desea ofertar a la carga del cliente", preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Enviar", style: .default) { (UIAlertAction) in
            let answer = ac.textFields![0]
            let ofertas = [
                "precio": Double(answer.text!) ?? 0.0,
                "transportista_id": (Auth.auth().currentUser?.uid)!] as [String : Any]
            Database.database().reference().child("cargas").child(self.carga!.id).child("ofertas").childByAutoId().setValue(ofertas)
            
            
        }
        let cancelBTN = UIAlertAction(title: "Cancelar", style: .default, handler: nil)

        ac.addAction(submitAction)
        ac.addAction(cancelBTN)
        UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagen_carga.sd_setImage(with: URL(string: carga!.imagen_url), completed: nil)
        lblDescripcion.text! = carga!.descripcion_carga
        lblRuta.text! = "\(carga!.ubicacion_inicio) - \(carga!.ubicacion_destino)"
        lblPrecio.text! = "\(carga!.precio)"

    }

}
