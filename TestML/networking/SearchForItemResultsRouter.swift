//
//  SearchForItemResultsRouter.swift
//  TestML
//
//  Created by Tomas on 04/06/2021.
//

import Foundation
import Alamofire

enum SearchForItemResultsRouter: URLRequestConvertible {
    case getItemResults
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getItemResults:
            return .get
        }
    }
    
    var path: URL {
        switch self {
        case .getItemResults:
            var urlComponents = URLComponents(string: Constants.Config.BaseURL + Constants.Config.SitesURLParam + Constants.Config.ProductSearchURL)!
            let defaults = UserDefaults.standard
            let offset = defaults.object(forKey: "offset") as? String
            let product = defaults.object(forKey: "product") as? String
            urlComponents.queryItems = [
                URLQueryItem(name: "q", value: product)//,
                //URLQueryItem(name: "offset", value: offset)
            ]
            return urlComponents.url!
        }
    }
    
    var headers: HTTPHeaders {
        switch self {
        case .getItemResults:
            return HTTPHeaders()
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        var url : URL
        var urlRequest : URLRequest

        url = path
        urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        print(urlRequest.url?.description as Any)
        urlRequest.allHTTPHeaderFields = headers.dictionary
        return urlRequest
    }
}
