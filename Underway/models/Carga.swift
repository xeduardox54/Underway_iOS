//
//  Carga.swift
//  Underway
//
//  Created by tkmiz on 6/19/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import Foundation
class Carga {
    var id: String = ""
    var descripcion_carga: String = ""
    var disponible: Bool = false
    var imagen_url: String = ""
    var nombre_carga: String = ""
    var owner_id: String = ""
    var peso: String = ""
    var precio: Double = 0
    var tipo: String = ""
    var ubicacion_destino: String = ""
    var ubicacion_inicio: String = ""
    var ofertas = [Oferta]()
}
