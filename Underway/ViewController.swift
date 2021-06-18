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
            var errorMessage = ""
            if error != nil{
                if let errCode = AuthErrorCode(rawValue: error!._code){
                    switch errCode {
                    case .userNotFound:
                        errorMessage = "El usuario no existe"
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al iniciar sesion. \(errorMessage)", accion: "Aceptar")
                        print(errorMessage)
                        break
                    case .invalidEmail:
                        errorMessage = "El formato del correo electronico es invalido."
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al iniciar sesion. \(errorMessage)", accion: "Aceptar")
                        print(errorMessage)
                        break
                    case .wrongPassword:
                        errorMessage = "La contraseña es incorrecta."
                        self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al iniciar sesion. \(errorMessage)", accion: "Aceptar")
                        print(errorMessage)
                        break
                    default:
                        print("Error desconocido:", error)
                    }
                }
            }else{
                /*
                self.navigationController?.pushViewController(HomeViewController(user: self.emailTextField.text!, view: "HomeViewController"), animated: true)
                */
                // let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
                let mainTabBarController = tabBarStoryboard.instantiateViewController(withIdentifier: "MainTabBarController")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
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
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnCANCELOK)
        present(alerta, animated: true, completion: nil)
    }

}

