//
//  SearchForItemResultsDelegate.swift
//  TestML
//
//  Created by Tomas on 02/06/2021.
//

import UIKit

protocol SearchForItemResultsDelegateProtocol {
    func loadMoreData(offset: Int, total: Int, limit: Int)
}

class SearchForItemResultsDelegate: NSObject, UITableViewDelegate {
    private var result: [ResultStruct]?
    private var paging: PagingStruct?
    var searchforItemResultsDelegateProtocol : SearchForItemResultsDelegateProtocol?
    
    func setResult(result: [ResultStruct]){
        self.result = result
    }
    
    func setPaging(paging: PagingStruct){
        self.paging = paging
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let lastElement = result?.count else {
            return
        }
        if indexPath.row == (lastElement - 1) {
            if let offset = paging?.offset,
               let total = paging?.total,
               let limit = paging?.limit,
               offset < total,
               offset < lastElement {
                
                searchforItemResultsDelegateProtocol?.loadMoreData(offset: offset, total: total, limit: limit)
            }
        }
    }
}
