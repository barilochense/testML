//
//  ItemResultsViewController.swift
//  TestML
//
//  Created by Tomas on 02/06/2021.
//

import UIKit

struct SearchForItemResultsData: Codable{
    var site_id: String?
    var query: String?
    var paging = [PagingStruct]()
    var results = [ResultsStruct]()
    var status: Int?
    var message: String?
    var cause: String?
    var error: String?
    
    init(json: [String: AnyObject?]) {
        self.site_id = json["site_id"] as? String ?? ""
        self.query = json["query"] as? String ?? ""
        
        if let allPaging = json["paging"] as? Dictionary<String, AnyObject>,
           !allPaging.isEmpty{
            paging.append(PagingStruct(json: allPaging))
        }
        
        if let allResults = json["results"] as? [Any],
           !allResults.isEmpty{
            results.append(ResultsStruct(json: allResults))
        }
        
        self.status = json["status"] as? Int
        self.message = json["message"] as? String ?? ""
        self.cause = json["cause"] as? String ?? ""
        self.error = json["error"] as? String ?? ""
    }
}

struct PagingStruct: Codable{
    var total: Int?
    var primary_results: Int?
    var offset: Int?
    var limit: Int?
    
    init(json: Dictionary<String, AnyObject?>) {
        self.total = json["total"] as? Int
        self.primary_results = json["primary_results"] as? Int
        self.offset = json["offset"] as? Int
        self.limit = json["limit"] as? Int
    }
}

struct ResultsStruct: Codable{
    var result = [ResultStruct]()
    
    init(json: [Any]) {
        for aResult in json {
            if let aResultDict = aResult as? Dictionary<String, AnyObject> {
                result.append(ResultStruct(json: aResultDict))
            }
        }
    }
}

struct ResultStruct: Codable{
    var id: String
    var site_id: String
    var title: String
    //var seller = [SellerStruct]()
    var price: Double?
    //var prices = [PricesStruct]()
    var sale_price: String?
    var currency_id: String
    var available_quantity: Int?
    var sold_quantity: Int?
    var buying_mode: String
    var listing_type_id: String
    var stop_time: String
    var condition: String
    var permalink: String
    var thumbnail: String
    var thumbnail_id: String
    var accepts_mercadopago: Bool
    //var installments = [Installments]()
    //var address = [Address]()
    //var shipping = [Shipping]()
    //var seller_address = [SellerAddress]()
    //var attributes = [Attribute]
    var original_price: Double?
    var category_id: String?
    var official_store_id: Int?
    var domain_id: String
    var catalog_product_id: String
    //var tags = [ResultTag]()
    var catalog_listing: Bool?
    var use_thumbnail_id: Bool
    var order_backend: Int?
    //var differential_pricing = [DifferentialPricing]
    
    init(json: Dictionary<String, AnyObject?>) {
        self.id = json["id"] as? String ?? ""
        self.site_id = json["site_id"] as? String ?? ""
        self.title = json["title"] as? String ?? ""
        self.price = json["price"] as? Double
        self.sale_price = json["sale_price"] as? String ?? ""
        self.currency_id = json["currency_id"] as? String ?? ""
        self.available_quantity = json["available_quantity"] as? Int
        self.sold_quantity = json["sold_quantity"] as? Int
        self.buying_mode = json["buying_mode"] as? String ?? ""
        self.listing_type_id = json["listing_type_id"] as? String ?? ""
        self.stop_time = json["stop_time"] as? String ?? ""
        self.condition = json["condition"] as? String ?? ""
        self.permalink = json["permalink"] as? String ?? ""
        self.thumbnail = json["thumbnail"] as? String ?? ""
        self.thumbnail_id = json["thumbnail_id"] as? String ?? ""
        self.accepts_mercadopago = json["accepts_mercadopago"] as? Bool ?? false
        self.original_price = json["original_price"] as? Double
        self.category_id = json["category_id"] as? String ?? ""
        self.official_store_id = json["official_store_id"] as? Int
        self.domain_id = json["domain_id"] as? String ?? ""
        self.catalog_product_id = json["catalog_product_id"] as? String ?? ""
        self.catalog_listing = json["catalog_listing"] as? Bool ?? false
        self.use_thumbnail_id = json["use_thumbnail_id"] as? Bool ?? false
        self.order_backend = json["order_backend"] as? Int
    }
}


class SearchForItemResultsDelegate: NSObject, UITableViewDelegate {
    private var result: [ResultStruct]?
    
    func setResult(result: [ResultStruct]){
        self.result = result
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let result = result?[indexPath.row] else{
            return
        }
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductDetailVC") as! ProductDetailViewController
        
        
        guard let rootViewController : UIViewController = UIApplication.shared.keyWindow?.rootViewController else {
            fatalError("there is no view controller presented on screen.")
        }
        
        var presentedVc = rootViewController.presentedViewController
        
        if let navController = rootViewController as? UINavigationController,
            let lastVC = navController.viewControllers.last{
            if let presentedViewController = lastVC.presentedViewController  {
                presentedVc = presentedViewController
            } else {
                presentedVc = lastVC
            }
        }
        vc.result = result
        
        presentedVc?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

class SearchForItemResultsDataSource: NSObject, UITableViewDataSource{
    
    private var result: [ResultStruct]?
    private var paging: PagingStruct?
    
    func setResult(result: [ResultStruct]){
        self.result = result
    }
    
    func setPaging(paging: PagingStruct){
        self.paging = paging
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = result?.count else {
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let result = result else  {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsTableViewCell", for: indexPath) as! SearchForItemResultsTableViewCell
        cell.labelItem.text = result[indexPath.row].title
        cell.priceItem.text = "$ " + (result[indexPath.row].price?.description ?? "")
        do {
            if let http = URL(string: result[indexPath.row].thumbnail),
               var comps = URLComponents(url: http, resolvingAgainstBaseURL: false) {
                comps.scheme = "https"
                let https = comps.url!
                let data = try Data(contentsOf: https)
                cell.imageItem.image = UIImage(data: data)
            }
        }
        catch{
            print(error)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let lastElement = result?.count else {
            return
        }
        if indexPath.row == lastElement {
            //  Check which offset should be sent on the URL
            let totalPages = (paging?.total)! / (paging?.limit)!
            let offset = paging?.offset
            if offset! < totalPages {
                let defaults = UserDefaults.standard
                var newOffset = offset! + 1
                defaults.set(newOffset.description, forKey: "offset")
                let api : SearchForItemResultsType = SearchForItemResultsManager()
                //api.getSearchForItemResults(finishedBlock: <#T##(([SearchForItemResultsData]) -> Void)##(([SearchForItemResultsData]) -> Void)##([SearchForItemResultsData]) -> Void#>)
            }
            
            
            // Make call to get more data
            
            // Check for going up
            
            
        }
    }
}


class ItemResultsViewController: UIViewController {
    var itemResults: [SearchForItemResultsData]?
    var paging: PagingStruct?
    var dataSource: SearchForItemResultsDataSource = SearchForItemResultsDataSource()
    var delegate: SearchForItemResultsDelegate = SearchForItemResultsDelegate()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = delegate
        setUpDelegates()
        tableView.reloadData()
    }
    
    func setUpDelegates(){
        guard let itemResults = itemResults else{
            getResults()
            return
        }
        self.tableView.isHidden = false
        if let resultArray = itemResults.first?.results.first?.result {
            self.dataSource.setResult(result: resultArray)
            self.delegate.setResult(result: resultArray)
        }
        if let pagingResult = itemResults.first?.paging.first {
            self.dataSource.setPaging(paging: pagingResult)
        }
    }
    
    func getResults() {
        tableView.isHidden = true
        activityIndicator.startAnimating()
        searchForItem(finishedBlock: { [weak self] (finished, itemResults) in
            guard let itemResults = itemResults,
                !itemResults.isEmpty,
                let `self` = self else{
                return
            }
            DispatchQueue.main.async { [self] in
                print(itemResults)
                if itemResults.first?.status == 404 {
                    if let error = itemResults.first {
                        NSLog("%@", "*************************** ERROR ***************************")
                        NSLog("%@%@", "Status: ", error.status?.description ?? "")
                        NSLog("%@%@", "Message: ", error.message ?? "")
                        NSLog("%@%@", "Cause: ", error.cause ?? "")
                        NSLog("%@%@", "Error: ", error.error ?? "")
                    }
                    
                    let alert = UIAlertController(title: "Atención", message: "Hubo un error en la búsqueda. Por favor, contacte a soporte técnico de esta aplicación", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in self.navigationController?.popViewController(animated: true) })
                    self.present(alert, animated: true, completion: nil)
                } else {
                    `self`.itemResults = itemResults
                    `self`.setUpDelegates()
                    `self`.tableView.reloadData()
                    `self`.activityIndicator.stopAnimating()
                }
            }
        })
    }
    
    func searchForItem(finishedBlock: @escaping ((Bool, [SearchForItemResultsData]?) -> Void)){
        let api : SearchForItemResultsType = SearchForItemResultsManager()
        api.getSearchForItemResults { (offers) in
            if offers.isEmpty {
                finishedBlock(false, nil)
                let alert = UIAlertController(title: "Atención", message: "Esta búsqueda no tuvo resultados. Por favor, vuelva a buscar otro producto", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in `self`.navigationController?.popViewController(animated: true) })
                `self`.present(alert, animated: true, completion: nil)
                return
            }
            finishedBlock(true, offers)
        }
    }
}

