//
//  CargaFormViewController.swift
//  Underway
//
//  Created by tkmiz on 6/16/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CargaFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var imagePicker = UIImagePickerController()
    var imagenID = NSUUID().uuidString
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tipoTextField: UITextField!
    @IBOutlet weak var pesoTextField: UITextField!
    @IBOutlet weak var ubicacionRecojoTextField: UITextField!
    @IBOutlet weak var ubicacionDestinoTextField: UITextField!
    @IBOutlet weak var saveDataButton: UIButton!
    @IBOutlet weak var swEstado: UISwitch!
    
    @IBAction func imageButton(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveDataButton(_ sender: Any) {
        saveDataButton.isEnabled = false
        let imagenesFolder = Storage.storage().reference().child("cargas_imagenes")
        let imagenData = imageView.image?.jpegData(compressionQuality: 0.50)
        let cargarImagen = imagenesFolder.child("\(imagenID).jpg")
        cargarImagen.putData(imagenData!, metadata: nil){ (metadata, error) in
            if error != nil {
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al subir la imagen. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
                self.saveDataButton.isEnabled = true
                print("Ocurrio un error al subir la imagen \(error) ")
                return
            }else{
                cargarImagen.downloadURL(completion: {(url, error) in
                    guard let enlaceURL = url else{
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                        self.saveDataButton.isEnabled = true
                        print("Ocurrio un error al obtener información de imagen \(error)")
                        return
                    }
                    let carga = ["estado": self.swEstado.isOn, "imagen_url": url?.absoluteString, "lugar_destino": self.ubicacionRecojoTextField.text!, "lugar_inicio": self.ubicacionDestinoTextField.text!, "peso": self.pesoTextField.text!, "tipo": self.tipoTextField.text!, "usuario_id": (Auth.auth().currentUser?.uid)!] as [String : Any]
                    Database.database().reference().child("cargasPruebaRodrigo").childByAutoId().setValue(carga)                })
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        saveDataButton.layer.cornerRadius = 5
        imagePicker.delegate = self
        
        saveDataButton.isEnabled = false
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        saveDataButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
