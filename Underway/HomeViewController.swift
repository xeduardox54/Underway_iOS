//
//  HomeViewController.swift
//  Underway
//
//  Created by tkmiz on 6/15/21.
//  Copyright © 2021 Quinto Semestre. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    var user = ""
    @IBOutlet weak var userLabelView: UILabel!
    
    init(user: String, view: String) {
        self.user = user
        super.init(nibName: view, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userLabelView.text = user
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
