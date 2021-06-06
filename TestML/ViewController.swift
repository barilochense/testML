//
//  ViewController.swift
//  TestML
//
//  Created by Tomas on 30/05/2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var searchBox: UITextField!
    @IBAction func searchButtonPress(_ sender: Any) {
        if searchBox.text != "" && searchBox.text != nil {
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ItemResultsVC") as! ItemResultsViewController
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alert = UIAlertController(title: "Atención", message: "Debe introducir un término de búsqueda", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

