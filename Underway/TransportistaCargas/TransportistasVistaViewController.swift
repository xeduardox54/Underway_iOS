import UIKit
import Firebase
import SDWebImage

class CargasTablaCell:UITableViewCell {
    @IBOutlet weak var imagen_carga: UIImageView!
    @IBOutlet weak var lblDireccion: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBAction func btnOfertar(_ sender: Any) {
        print("Clic")
        let ac = UIAlertController(title: "Realizar Oferta", message: "Ingrese el precio que desea ofertar a la carga del cliente", preferredStyle: .alert)
        
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Enviar", style: .default) { (UIAlertAction) in
            let answer = ac.textFields![0]
            print(answer.text!)
            
//           
        }
        let cancelBTN = UIAlertAction(title: "Cancelar", style: .default, handler: nil)

        ac.addAction(submitAction)
        ac.addAction(cancelBTN)
        UIApplication.shared.keyWindow?.rootViewController?.present(ac, animated: true, completion: nil)
        
    }
    
}

class TransportistasVistaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla_cargas: UITableView!
    
    var cargas:[Carga] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla_cargas.delegate = self
        tabla_cargas.dataSource = self
        Database.database().reference().child("cargas").observe(DataEventType.childAdded, with: {(snapshot) in print(snapshot)
            
            let carga = Carga()
            carga.id = snapshot.key
            carga.owner_id = (snapshot.value as! NSDictionary)["owner_id"] as! String
            carga.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            carga.peso = (snapshot.value as! NSDictionary)["peso"] as! String
            carga.ubicacion_inicio = (snapshot.value as! NSDictionary)["ubicacion_inicio"] as! String
            carga.ubicacion_destino = (snapshot.value as! NSDictionary)["ubicacion_destino"] as! String
            carga.imagen_url = (snapshot.value as! NSDictionary)["imagen_url"] as! String
            carga.disponible = (snapshot.value as! NSDictionary)["disponible"] as! Bool
            carga.descripcion_carga = (snapshot.value as! NSDictionary)["descripcion_carga"] as! String
            carga.precio = (snapshot.value as! NSDictionary)["precio"] as! Double
            self.cargas.append(carga)
            self.tabla_cargas.reloadData()
             
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cargas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carga", for: indexPath) as! CargasTablaCell
        let carga = cargas[indexPath.row]
        cell.lblDescripcion?.text = carga.descripcion_carga
        cell.lblDireccion?.text = "\(carga.ubicacion_inicio) - \(carga.ubicacion_destino)"
        cell.lblPrecio?.text = "$. \(carga.precio)"
        cell.imagen_carga?.sd_setImage(with: URL(string: carga.imagen_url), completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cargaelegida = cargas[indexPath.row]
        performSegue(withIdentifier: "segueDetallesCarga", sender: cargaelegida)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! DetallesCargaViewController
        siguienteVC.carga = sender as! Carga
    }
    

}
