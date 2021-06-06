//
//  Constants.swift
//  TestML
//
//  Created by Tomas on 02/06/2021.
//

import Foundation
import UIKit

struct App {
    static let shared = App()
    static let infoPath = Bundle.main.path(forResource: "Info", ofType: ".plist")
    let configDictionary = NSDictionary(contentsOfFile: infoPath ?? "")
    
    static func getValueFromInfoPlist(with key: String) -> String {
        guard let dictionary = App.shared.configDictionary,
            let value = dictionary[key] as? String else {
            return String()
        }
        return value
    }
    
    static func getAnyValueFromInfoPlist(with key: String) -> AnyObject {
        guard let dictionary = App.shared.configDictionary,
            let value = dictionary[key] else {
            return String() as AnyObject
        }
        return value as AnyObject
    }
}

struct Constants {
    struct Config {
        static var BaseURL: String = App.getValueFromInfoPlist(with: "BaseURL")
        static var SitesURLParam: String = App.getValueFromInfoPlist(with: "SitesURLParam")
        static var ProductSearchURL: String = App.getValueFromInfoPlist(with: "ProductSearchURL")
    }
}
