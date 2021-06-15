//
//  RegisterViewController.swift
//  Underway
//
//  Created by tkmiz on 6/14/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var dniTextField: UITextField!
    @IBAction func registerButton(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user, error) in
            print("Intentando crear un usuario")
            if error != nil {
                print("Se presento el siguiente error al crear el usuario: \(error)")
                self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al registrar el Usuario. Verifique su conexion a internet y vuelva a intentarlo.", accion: "Aceptar")
            }else{
                let userDB = ["email": self.emailTextField!.text, "name": self.nameTextField!.text, "surname": self.surnameTextField!.text, "dni": self.dniTextField!.text]
                print("El usuario fue creado exitosamente")
                Database.database().reference().child("users").child(user!.user.uid).setValue(userDB)
                self.mostrarAlerta(titulo: "Nuevo Usuario", mensaje: "El usuario:\(self.emailTextField.text!) se creo correctamente..", accion: "Aceptar")
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }

}
