
import UIKit
import SDWebImage

class DetallesCargaViewController: UIViewController {
    
    var carga: Carga?

    @IBOutlet weak var imagen_carga: UIImageView!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblRuta: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagen_carga.sd_setImage(with: URL(string: carga!.imagen_url), completed: nil)
        lblDescripcion.text! = carga!.descripcion_carga
        lblRuta.text! = "\(carga!.ubicacion_inicio) - \(carga!.ubicacion_destino)"
        lblPrecio.text! = "\(carga!.precio)"

    }

}
