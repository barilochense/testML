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
    var siteID: String
    var title: String
    //var seller = [SellerStruct]()
    var price: Double?
    //var prices = [PricesStruct]()
    var salePrice: String?
    var currencyID: String
    var availableQuantity: Int?
    var soldQuantity: Int?
    var buyingMode: String
    var listingTypeID: String
    var stopTime: String
    var condition: String
    var permalink: String
    var thumbnail: String
    var thumbnailID: String
    var acceptsMercadopago: Bool
    //var installments = [Installments]()
    //var address = [Address]()
    //var shipping = [Shipping]()
    //var sellerAddress = [SellerAddress]()
    //var attributes = [Attribute]
    var originalPrice: Double?
    var categoryID: String?
    var officialStoreID: Int?
    var domainID: String
    var catalogProductID: String
    //var tags = [ResultTag]()
    var catalogListing: Bool?
    var useThumbnailID: Bool
    var orderBackend: Int?
    //var differentialPricing = [DifferentialPricing]
    
    init(json: Dictionary<String, AnyObject?>) {
        self.id = json["id"] as? String ?? ""
        self.siteID = json["siteID"] as? String ?? ""
        self.title = json["title"] as? String ?? ""
        self.price = json["price"] as? Double
        self.salePrice = json["salePrice"] as? String ?? ""
        self.currencyID = json["currencyID"] as? String ?? ""
        self.availableQuantity = json["availableQuantity"] as? Int
        self.soldQuantity = json["soldQuantity"] as? Int
        self.buyingMode = json["buyingMode"] as? String ?? ""
        self.listingTypeID = json["listingTypeID"] as? String ?? ""
        self.stopTime = json["stopTime"] as? String ?? ""
        self.condition = json["condition"] as? String ?? ""
        self.permalink = json["permalink"] as? String ?? ""
        self.thumbnail = json["thumbnail"] as? String ?? ""
        self.thumbnailID = json["thumbnailID"] as? String ?? ""
        self.acceptsMercadopago = json["acceptsMercadopago"] as? Bool ?? false
        self.originalPrice = json["originalPrice"] as? Double
        self.categoryID = json["categoryID"] as? String ?? ""
        self.officialStoreID = json["officialStoreID"] as? Int
        self.domainID = json["domainID"] as? String ?? ""
        self.catalogProductID = json["catalogProductID"] as? String ?? ""
        self.catalogListing = json["catalogListing"] as? Bool ?? false
        self.useThumbnailID = json["useThumbnailID"] as? Bool ?? false
        self.orderBackend = json["orderBackend"] as? Int
    }
}


class SearchForItemResultsDelegate: NSObject, UITableViewDelegate{
    private var itemResults: [SearchForItemResultsData]?
    
    func setItemResults(itemResults: [SearchForItemResultsData]){
        self.itemResults = itemResults
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let searchForItemResultsData = itemResults?[indexPath.row] else{
            return
        }/*
        if let listProductVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "listProductVC") as? ListProductViewController,
           let path = searchForItemResultsData.link {
            listProductVC.performSearchFromTitleHomeLink(path: "/busca?"+path)*/
            /*
            //MARK:- Search query from title homolinkeable
            func performSearchFromTitleHomeLink(path : String) {
                self.queryToSearch = path
                self.isFromCarrousel = true
                UIViewController.returnPresentedViewController().navigationController?.pushViewController(self, animated: true)
            }
            
            //listProductVC.title = searchForItemResultsData.name
        }*/
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
}

class SearchForItemResultsDataSource: NSObject, UITableViewDataSource{
    
    private var result: [ResultStruct]?
    func setItemResults(result: [ResultStruct]){
        self.result = result
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
        print(result[indexPath.row].title)
        cell.labelItem.text = result[indexPath.row].title
        
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
}


class ItemResultsViewController: UIViewController {
    var itemResults: [SearchForItemResultsData]?
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
            self.dataSource.setItemResults(result: resultArray)
        }
        
        self.delegate.setItemResults(itemResults: itemResults)
    }
    
    func getResults() {
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

