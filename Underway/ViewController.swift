//
//  ViewController.swift
//  Underway
//
//  Created by Eduardo Justo Rodriguez Herrera on 6/13/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginDataView: UIView!
    @IBOutlet weak var signButtonView: UIButton!
    
    @IBAction func signButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
                let alerta = UIAlertController(title: "Iniciar Sesion", message: "El Usuario \(self.emailTextField.text!) no existe. Cree un nuevo usuario", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Crear Usuario", style: .default, handler: {(UIAlertAction) in
                    // self.performSegue(withIdentifier: "registrarUsuarioSegue", sender: nil)
                    print("Registrar usuario")
                })
                let btnCANCEL = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                alerta.addAction(btnOK)
                alerta.addAction(btnCANCEL)
                self.present(alerta, animated: true, completion: nil)
            }else{
                self.navigationController?.pushViewController(HomeViewController(user: self.emailTextField.text!, view: "HomeViewController"), animated: true)
                print("Inicio de sesion exitoso")
            }
        }
    }
    @IBAction func registerButton(_ sender: Any) {
        self.performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginDataView.layer.cornerRadius = 10
        loginDataView.layer.shadowColor = UIColor.black.cgColor
        loginDataView.layer.shadowOffset = CGSize(width: 2, height: 2)
        loginDataView.layer.shadowOpacity = 0.4
        loginDataView.layer.shadowRadius = 4
        signButtonView.layer.cornerRadius = 5
        
    }


}

