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
import SDWebImage

class TableViewCell:UITableViewCell{
    // Outlets de los elemetos de la celda
    @IBOutlet weak var imageCellView: UIImageView!
    @IBOutlet weak var titleCellView: UILabel!
    @IBOutlet weak var descriptionCellView: UILabel!
    @IBOutlet weak var offersCellView: UILabel!
    
    override func draw(_ rect: CGRect) {
        imageCellView?.layer.cornerRadius = (imageCellView?.bounds.height)! / 2
        imageCellView?.clipsToBounds = true
        
        offersCellView?.layer.cornerRadius = (offersCellView?.frame.size.height)! / 2
        offersCellView?.layer.masksToBounds = true
    }
}

class CargasUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var cargas:[Carga] = []
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        Database.database().reference().child("cargas").observe(DataEventType.childAdded, with: {(snapshot) in
            let carga = Carga()
            carga.id = snapshot.key
            carga.nombre_carga = (snapshot.value as! NSDictionary)["nombre_carga"] as! String
            carga.owner_id = (snapshot.value as! NSDictionary)["owner_id"] as! String
            carga.descripcion_carga = (snapshot.value as! NSDictionary)["descripcion_carga"] as! String
            carga.imagen_url = (snapshot.value as! NSDictionary)["imagen_url"] as! String
            carga.ubicacion_inicio = (snapshot.value as! NSDictionary)["ubicacion_inicio"] as! String
            carga.ubicacion_destino = (snapshot.value as! NSDictionary)["ubicacion_destino"] as! String
            carga.peso = (snapshot.value as! NSDictionary)["peso"] as! String
            carga.precio = (snapshot.value as! NSDictionary)["precio"] as! Double
            carga.disponible = (snapshot.value as! NSDictionary)["disponible"] as! Bool
            carga.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            
            if snapshot.hasChild("ofertas"){
                for offer in (snapshot.value as! NSDictionary)["ofertas"] as! NSDictionary{
                    let oferta = Oferta()
                    oferta.id = offer.key as! String
                    oferta.precio = (offer.value as! NSDictionary)["precio"] as! Double
                    oferta.transportista_id = (offer.value as! NSDictionary)["transportista_id"] as! String
                    carga.ofertas.append(oferta)
                }
            }
            
            if(carga.owner_id == (Auth.auth().currentUser?.uid)!){
                self.cargas.append(carga)
                self.tableView.reloadData()
            }
        })
        
        Database.database().reference().child("cargas").observe(DataEventType.childChanged, with: {(snapshot) in
            let cargaChanged = Carga()
            cargaChanged.id = snapshot.key
            cargaChanged.nombre_carga = (snapshot.value as! NSDictionary)["nombre_carga"] as! String
            cargaChanged.owner_id = (snapshot.value as! NSDictionary)["owner_id"] as! String
            cargaChanged.descripcion_carga = (snapshot.value as! NSDictionary)["descripcion_carga"] as! String
            cargaChanged.imagen_url = (snapshot.value as! NSDictionary)["imagen_url"] as! String
            cargaChanged.ubicacion_inicio = (snapshot.value as! NSDictionary)["ubicacion_inicio"] as! String
            cargaChanged.ubicacion_destino = (snapshot.value as! NSDictionary)["ubicacion_destino"] as! String
            cargaChanged.peso = (snapshot.value as! NSDictionary)["peso"] as! String
            cargaChanged.precio = (snapshot.value as! NSDictionary)["precio"] as! Double
            cargaChanged.disponible = (snapshot.value as! NSDictionary)["disponible"] as! Bool
            cargaChanged.tipo = (snapshot.value as! NSDictionary)["tipo"] as! String
            

            
            if(cargaChanged.owner_id == (Auth.auth().currentUser?.uid)!){
                var iterator = 0
                if snapshot.hasChild("ofertas"){
                    for offer in (snapshot.value as! NSDictionary)["ofertas"] as! NSDictionary{
                        let oferta = Oferta()
                        oferta.id = offer.key as! String
                        oferta.precio = (offer.value as! NSDictionary)["precio"] as! Double
                        oferta.transportista_id = (offer.value as! NSDictionary)["transportista_id"] as! String
                        cargaChanged.ofertas.append(oferta)
                    }
                }
                for carga in self.cargas{
                    if carga.id == snapshot.key{
                        self.cargas[iterator] = cargaChanged
                    }
                    iterator += 1
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        if cargas.count == 0 {
            cell.titleCellView?.text = "No tienes cargas"
        } else {

            let carga = cargas[indexPath.row]
            cell.titleCellView?.text = carga.nombre_carga.isEmpty ? "Sin Titulo" : carga.nombre_carga
            cell.descriptionCellView?.text = carga.descripcion_carga.isEmpty ? "Sin Titulo" : carga.descripcion_carga
            cell.imageCellView?.sd_setImage(with: URL(string: carga.imagen_url), completed: nil)
            cell.offersCellView?.text = carga.ofertas.count == 0 ? "0" : String(carga.ofertas.count)
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
