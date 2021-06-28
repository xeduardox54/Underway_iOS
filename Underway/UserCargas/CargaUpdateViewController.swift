import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol CargaSendingDelegateProtocol{
    func sendDataToVerCargaViewController(miCarga: Carga)
}

class CargaUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var delegate:CargaSendingDelegateProtocol? = nil
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
        if self.delegate != nil{
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

                        let refChild = Database.database().reference().child("cargas").child(self.carga.id)
                        refChild.child("descripcion_carga").setValue(self.descripcionTextField.text!)
                        refChild.child("disponible").setValue(self.swEstado.isOn)
                        refChild.child("imagen_url").setValue(url?.absoluteString ?? "")
                        refChild.child("nombre_carga").setValue(self.nombreTextField.text!)
                        refChild.child("owner_id").setValue((Auth.auth().currentUser?.uid)!)
                        refChild.child("peso").setValue(self.pesoTextField.text!)
                        refChild.child("precio").setValue(Double(self.precioTextField.text!) ?? 0.0)
                        refChild.child("tipo").setValue(self.tipoTextField.text!)
                        refChild.child("ubicacion_destino").setValue(self.ubicacionInicioTextField.text!)
                        refChild.child("ubicacion_inicio").setValue(self.ubicacionDestinoTextField.text!)
                        
                        self.carga.descripcion_carga = self.descripcionTextField.text!
                        self.carga.disponible = self.swEstado.isOn
                        self.carga.imagen_url = url?.absoluteString ?? ""
                        self.carga.nombre_carga = self.nombreTextField.text!
                        self.carga.peso = self.pesoTextField.text!
                        self.carga.precio = Double(self.precioTextField.text!) ?? 0.0
                        self.carga.tipo = self.tipoTextField.text!
                        self.carga.ubicacion_destino = self.ubicacionInicioTextField.text!
                        self.carga.ubicacion_inicio = self.ubicacionDestinoTextField.text!
                        self.mostrarAlerta(titulo: "Crear Carga", mensaje: "La carga se actualizo correctamente.", accion: "Aceptar")
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        // Do any additional setup after loading the view.
        nombreTextField.text = carga.nombre_carga
        imageView.sd_setImage(with: URL(string: carga.imagen_url), completed: nil)
        descripcionTextField.text = carga.descripcion_carga
        tipoTextField.text = carga.tipo
        pesoTextField.text = carga.peso
        precioTextField.text = String(carga.precio)
        swEstado.isOn = carga.disponible
        ubicacionInicioTextField.text = carga.ubicacion_inicio
        ubicacionDestinoTextField.text = carga.ubicacion_destino
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String){
        if self.delegate != nil {
            let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
            let btnCANCELOK = UIAlertAction(title: accion, style: .default, handler: {(UIAlertAction) in
                self.delegate?.sendDataToVerCargaViewController(miCarga: self.carga)
                self.navigationController?.popViewController(animated: true)
            })
            alerta.addAction(btnCANCELOK)
            present(alerta, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        print("Imagen picker", image)
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        savedButton.isEnabled = true
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
