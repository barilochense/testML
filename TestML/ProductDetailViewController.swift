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
    
    var result: ResultStruct?
    /*
    var dataSourceProduct: ProductCollectionViewSource?
    
    var updater : UpdaterResultsSearchBar = UpdaterResultsSearchBar()
    
    //for search
    var productsReceivedFromSearch: [ProductStruct]?
    var queryToSearch: String?
    var categoryPath: [String]?
    var isFromCarrousel : Bool = false
    
    ///Object for paging. "initialValue" CANNOT BE less than or equals 0
    var pageRange: PageRange = PageRange(initialValue: 0, sumRange: 15, limit: 15)
    var pageRangeVotic: PageRangeVotic = PageRangeVotic(initialPage: 0, sumPage: 1, limitPages: 1)
    var presentedProducts: [ProductStruct] = [ProductStruct]()
    */
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
