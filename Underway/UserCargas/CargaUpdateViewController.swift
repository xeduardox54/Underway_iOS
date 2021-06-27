//
//  CargaUpdateViewController.swift
//  Underway
//
//  Created by tkmiz on 6/21/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CargaUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    var carga = Carga()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nombreTextField: UITextField!
    @IBOutlet weak var descripcionTextField: UITextField!
    @IBOutlet weak var tipoTextField: UITextField!
    @IBOutlet weak var ubicacionInicioTextField: UITextField!
    @IBOutlet weak var ubicacionDestinoTextField: UITextField!
    @IBOutlet weak var pesoTextField: UITextField!
    @IBOutlet weak var swEstado: UISwitch!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var precioTextField: UITextField!
    
    @IBAction func imageTapped(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        savedButton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("cargas_imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        cargarImagen.putData(imagenData!, metadata: nil){ (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                self.savedButton.isEnabled = true
                print("Ocurrio un error al subir la imagen")
                return
            }else{
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                        self.savedButton.isEnabled = true
                        print("Ocurrio un error al obtener información de imagen")
                        return
                    }
                    let cargaUpdate = [
                        "descripcion_carga": self.descripcionTextField.text!,
                        "disponible": self.swEstado.isOn,
                        "imagen_url": url?.absoluteString ?? "",
                        "nombre_carga": self.nombreTextField.text!,
                        "owner_id": (Auth.auth().currentUser?.uid)!,
                        "peso": self.pesoTextField.text!,
                        "precio": Double(self.precioTextField.text!) ?? 0.0,
                        "tipo": self.tipoTextField.text!,
                        "ubicacion_destino": self.ubicacionInicioTextField.text!,
                        "ubicacion_inicio": self.ubicacionDestinoTextField.text!,
                        ] as [String : Any]
                    Database.database().reference().child("cargas").child(self.carga.id).setValue(cargaUpdate)
                    self.mostrarAlerta(titulo: "Crear Carga", mensaje: "La carga se guardo correctamente.", accion: "Aceptar")
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(carga)
        nombreTextField.text = carga.nombre_carga
        imageView.sd_setImage(with: URL(string: carga.imagen_url), completed: nil)
        descripcionTextField.text = carga.descripcion_carga
        tipoTextField.text = carga.tipo
        pesoTextField.text = carga.peso
        precioTextField.text = String(carga.precio)
        swEstado.isEnabled = carga.disponible
        ubicacionInicioTextField.text = carga.ubicacion_inicio
        ubicacionDestinoTextField.text = carga.ubicacion_destino
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: {(UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        })
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        savedButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
