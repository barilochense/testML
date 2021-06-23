//
//  ItemResultsViewController.swift
//  TestML
//
//  Created by Tomas on 02/06/2021.
//

import UIKit

class ItemResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var root = Root(site_id: "", query: "", paging: nil, results: [])
    var results = [Results]()
    var paging = Paging(total: 0, primary_results: 0, offset: 0, limit: 0)
    var isPaging = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.isHidden = true
        setOffsetTo(offset: 0)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        getResults {}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = results[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultsTableViewCell", for: indexPath) as! SearchForItemResultsTableViewCell
        
        cell.labelItem.text = result.title
        cell.priceItem.text = "$ " + (result.price?.description ?? "")
        if let thumbnail_id = result.thumbnail_id {
            let url = "https://http2.mlstatic.com/D_NQ_NP_" + thumbnail_id + "-R.jpg"
            print(url)
            cell.imageItem.imageURL = url
            cell.imageItem.image = nil
            cell.imageItem.load(urlString: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalCount = results.count
        if indexPath.row == (totalCount - 1),
           !isPaging {
            if let offset = paging.offset,
               let total = paging.total,
               let limit = paging.limit,
               offset < total,
               offset < totalCount {
                setOffsetTo(offset: (offset + limit))
                getResults {}
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = results[indexPath.row]
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
    
    func getResults(completed: @escaping () -> ()) {
        isPaging = true
        let url = getURL()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                do {
                    self.root = try JSONDecoder().decode(Root.self, from: data!)
                    if let paging = self.root.paging {
                        self.paging = paging
                    }
                    if let results = self.root.results {
                        self.results.append(contentsOf: results)
                    }
                    DispatchQueue.main.async {
                        self.activityIndicator.isHidden = true
                        self.activityIndicator.stopAnimating()
                        self.tableView.reloadData()
                        self.isPaging = false
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func getURL() -> URL {
        var urlComponents = URLComponents(string: Constants.Config.BaseURL + Constants.Config.SitesURLParam + Constants.Config.ProductSearchURL)!
        let defaults = UserDefaults.standard
        let offset = defaults.object(forKey: "offset") as? String ?? "0"
        let product = defaults.object(forKey: "product") as? String
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: product),
            URLQueryItem(name: "offset", value: offset)
        ]
        return urlComponents.url!
    }
    
    func setOffsetTo(offset: Int) {
        let defaults = UserDefaults.standard
        defaults.set(offset.description, forKey: "offset")
    }
    
    
    /*
    
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
                    if itemResults.first?.paging.first?.offset == 0 {
                        `self`.itemResults = itemResults
                    } else {
                        /*
                        if let newResults = itemResults.first?.results.first?.result {
                            `self`.itemResults?.first?.results.first?.result.f: newResults)
                        }*/
                    }
                    `self`.setUpDelegates()
                    `self`.tableView.reloadData()
                    `self`.activityIndicator.stopAnimating()
                }
     }
        })
    }
    */
}
