//
//  SearchForItemResultsAPI.swift
//  TestML
//
//  Created by Tomas on 02/06/2021.
//

import Foundation
import Alamofire


protocol SearchForItemResultsAPI {
    func retrieveWithRequest(request: URLRequestConvertible,
                                     finishedBlock: @escaping (([SearchForItemResultsData])->Void))
}

extension SearchForItemResultsAPI {
    
    func retrieveWithRequest(request: URLRequestConvertible,
                                     finishedBlock: @escaping (([SearchForItemResultsData])->Void)){
        AF.request(request).responseJSON(completionHandler: { (response) in

            switch response.result {
            case let .success(value):
                guard let itemResults = value as? Dictionary<String,AnyObject> else {
                    return finishedBlock([SearchForItemResultsData]())
                }
                
                var itemResultsReturn = [SearchForItemResultsData]()
                
                let itemResultsStruct: SearchForItemResultsData = SearchForItemResultsData(json: itemResults)
                itemResultsReturn.append(itemResultsStruct)
                
                finishedBlock(itemResultsReturn)
                
            case .failure(let error):
                print("====== Alamo error ====")
                print(error)
                finishedBlock([SearchForItemResultsData]())
            }
        })
    }
}

protocol SearchForItemResultsType {
    func getSearchForItemResults(finishedBlock: @escaping (([SearchForItemResultsData]) -> Void))
}

struct SearchForItemResultsManager : SearchForItemResultsAPI, SearchForItemResultsType {
    
    static let shared = SearchForItemResultsManager()
    
    func getSearchForItemResults(finishedBlock: @escaping (([SearchForItemResultsData]) -> Void)) {
        retrieveWithRequest(request: SearchForItemResultsRouter.getItemResults,
                                          finishedBlock: finishedBlock)
    }
}
