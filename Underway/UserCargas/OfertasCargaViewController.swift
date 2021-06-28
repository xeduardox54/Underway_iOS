//
//  OfertasCargaViewController.swift
//  Underway
//
//  Created by tkmiz on 6/27/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class OfertasCargaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var carga = Carga()
    var usuarios:[User] = []
    @IBOutlet weak var tableViewOfertas: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOfertas.delegate = self
        tableViewOfertas.dataSource = self
        // Do any additional setup after loading the view.
        
        Database.database().reference().child("usuarios").observe(DataEventType.childAdded, with: {(snapshot) in
            let user = User()
            user.id = snapshot.key
            user.DNI = (snapshot.value as! NSDictionary)["DNI"] as! String
            user.apellidos = (snapshot.value as! NSDictionary)["apellidos"] as! String
            user.correo = (snapshot.value as! NSDictionary)["correo"] as! String
            user.nombres = (snapshot.value as! NSDictionary)["nombres"] as! String
            user.permiso_transporte = (snapshot.value as! NSDictionary)["permiso_transporte"] as! Bool
            self.usuarios.append(user)
            self.tableViewOfertas.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return carga.ofertas.count == 0 ? 0 : carga.ofertas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOfertas", for: indexPath)
        let oferta = carga.ofertas[indexPath.row]
        cell.textLabel?.text = String(oferta.precio)
        var user = User()
        for item in usuarios {
            if item.id == oferta.transportista_id{
                user = item
            }
        }
        cell.detailTextLabel?.text = user.nombres
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oferta = carga.ofertas[indexPath.row]
        if (carga.disponible) {
            let alerta = UIAlertController(title: "Oferta de Transporte", message: "¿Desea aceptar esta oferta?", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in
                // Database.database().reference().child("cargas").child(self.carga.id).child("ofertas").child(oferta.id).child("").setValue("Aceptado")
                Database.database().reference().child("cargas").child(self.carga.id).child("disponible").setValue(false)
            })
            let btnRECHAZAR = UIAlertAction(title: "Rechazar", style: .default, handler: {(UIAlertAction) in
                // Database.database().reference().child("cargas").child(self.carga.id).child("ofertas").child(oferta.id).child("").setValue("Rechazado")
                Database.database().reference().child("cargas").child(self.carga.id).child("disponible").setValue(true)
            })
            let btnCANCEL = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alerta.addAction(btnOK)
            alerta.addAction(btnCANCEL)
            alerta.addAction(btnRECHAZAR)
            present(alerta, animated: true, completion: nil)
        } else {
            let alerta = UIAlertController(title: "No Disponible", message: "Tu carga no esta disponible.", preferredStyle: .alert)
            let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alerta.addAction(btnOK)
            present(alerta, animated: true, completion: nil)
        }

    }

}
