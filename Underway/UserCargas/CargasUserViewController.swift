//
//  CargasUserViewController.swift
//  Underway
//
//  Created by tkmiz on 6/18/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CargasUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cargas:[Carga] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        Database.database().reference().child("cargas").observe(DataEventType.childAdded, with: {(carga_user) in
            let carga = Carga()
            carga.nombre_carga = (carga_user.value as! NSDictionary)["nombre_carga"] as! String
            carga.owner_id = (carga_user.value as! NSDictionary)["owner_id"] as! String
            carga.descripcion_carga = (carga_user.value as! NSDictionary)["descripcion_carga"] as! String
            carga.imagen_url = (carga_user.value as! NSDictionary)["imagen_url"] as! String
            carga.ubicacion_inicio = (carga_user.value as! NSDictionary)["ubicacion_inicio"] as! String
            carga.ubicacion_destino = (carga_user.value as! NSDictionary)["ubicacion_destino"] as! String
            carga.peso = (carga_user.value as! NSDictionary)["peso"] as! String
            carga.precio = (carga_user.value as! NSDictionary)["precio"] as! Double
            carga.disponible = (carga_user.value as! NSDictionary)["disponible"] as! Bool
            carga.tipo = (carga_user.value as! NSDictionary)["tipo"] as! String
            
            print((Auth.auth().currentUser?.uid)!)
            if(carga.owner_id == (Auth.auth().currentUser?.uid)!){
                self.cargas.append(carga)
                self.tableView.reloadData()
            }
        })
        Database.database().reference().child("cargas").observe(DataEventType.childRemoved, with: {(carga_user) in
                var iterator = 0
                for carga in self.cargas{
                    if carga.id == carga_user.key{
                        self.cargas.remove(at: iterator)
                    }
                    iterator += 1
                }
                self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cargas.count == 0{
            return 1
        } else {
            return cargas.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if cargas.count == 0 {
            cell.textLabel?.text = "No tienes cargas"
        } else {

            let carga = cargas[indexPath.row]
            cell.textLabel?.text = carga.nombre_carga
            cell.detailTextLabel?.text = carga.descripcion_carga
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let carga = cargas[indexPath.row]
        performSegue(withIdentifier: "verCargaSegue", sender: carga)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verCargaSegue" {
            let siguienteVC = segue.destination as! VerCargaViewController
            siguienteVC.carga = sender as! Carga
        }
    }
    
}
