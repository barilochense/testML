//
//  ProductDetailViewController.swift
//  TestML
//
//  Created by Tomas on 06/06/2021.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var price: UILabel!
    
    var result: Results?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentResult = result else{
            self.navigationController?.popViewController(animated: true)
            return
        }
        productName.text = currentResult.title
        price.text = "$ " + (currentResult.price?.description ?? "")
        
        do {
            if let thmb_id = result?.thumbnail_id {
                if let url = URL(string: "https://http2.mlstatic.com/D_NQ_NP_" + thmb_id + "-F.jpg") {
                    print(url)
                    let data = try Data(contentsOf: url)
                    productImage.image = UIImage(data: data)
                }
            }
            
        }
        catch{
            print(error)
        }
        
        // Do any additional setup after loading the view.
    }


}
