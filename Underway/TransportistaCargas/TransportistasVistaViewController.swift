import UIKit
import Firebase
import SDWebImage

class CargasTablaCell:UITableViewCell {
    @IBOutlet weak var imagen_carga: UIImageView!
    @IBOutlet weak var titulo_carga: UILabel!
}

class TransportistasVistaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tabla_cargas: UITableView!
    
    var cargas:[Carga] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabla_cargas.delegate = self
        tabla_cargas.dataSource = self
        Database.database().reference().child("cargasPrueba").observe(DataEventType.childAdded, with: {(snapshot) in print(snapshot)
            /*
            let carga = Carga()
            carga.carga_id = snapshot.key
            carga.usuario_id = (snapshot.value as! NSDictionary)["usuario_id"] as! String
            carga.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            carga.peso = (snapshot.value as! NSDictionary)["peso"] as! String
            carga.lugar_inicio = (snapshot.value as! NSDictionary)["lugar_inicio"] as! String
            carga.lugar_destino = (snapshot.value as! NSDictionary)["lugar_destino"] as! String
            carga.imagen_url = (snapshot.value as! NSDictionary)["imagen_url"] as! String
            carga.estado = (snapshot.value as! NSDictionary)["estado"] as! String
            self.cargas.append(carga)
            self.tabla_cargas.reloadData()
             */
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cargas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "carga", for: indexPath) as! CargasTablaCell
        let carga = cargas[indexPath.row]
        cell.titulo_carga.text = carga.tipo
        return cell
    }

}
