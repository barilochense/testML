//
//  SearchResults.swift
//  TestML
//
//  Created by Tomas on 21/06/2021.
//

import Foundation

struct Root: Decodable {
    let site_id: String?
    let query: String?
    let paging: Paging?
    let results: [Results]?
    
    init(site_id: String?, query: String? = nil, paging: Paging? = nil, results: [Results]? = []) {
        self.site_id = site_id
        self.query = query
        self.paging = paging
        self.results = results
    }
}

struct Paging: Decodable {
    let total: Int?
    let primary_results: Int?
    let offset: Int?
    let limit: Int?
    
    init(total: Int? = 0, primary_results: Int? = 0, offset: Int? = 0, limit: Int? = 0) {
        self.total = total
        self.primary_results = primary_results
        self.offset = offset
        self.limit = limit
    }
}

struct Results: Decodable {
    let id: String?
    let site_id: String?
    let title: String?
//    let seller: [Seller]
    let price: Float?
//    let prices: [Prices]
    let sale_price: Float?
    let currency_id: String?
    let available_quantity: Int?
    let sold_quantity: Int?
    let buying_mode: String?
    let listing_type_id: String?
    let stop_time: String?
    let condition: String?
    let permalink: String?
    let thumbnail: String?
    let thumbnail_id: String?
    let accepts_mercadopago: Bool?
//    let installments: [Installments]
//    let address: [Address]
//    let shipping: [Shipping]
//    let seller_address: [SellerAddress]
//    let attributes: [Attributes]
    let original_price: Float?
    let category_id: String?
    let official_store_id: String?
    let domain_id: String?
    let catalog_product_id: String?
//    let tags: [Tags]
    let catalog_listing: Bool?
    let use_thumbnail_id: Bool?
    let order_backend: Int?
}

struct Seller: Decodable {
    
}

struct Prices: Decodable {
    
}

struct Installments: Decodable {
    
}

struct Address: Decodable {
    
}

struct Shipping: Decodable {
    
}

struct SellerAddress: Decodable {
    
}

struct Attributes: Decodable {
    
}

struct Tags: Decodable {
    
}

struct SecondaryResults: Decodable {
    
}

struct RelatedResults: Decodable {
    
}

struct Sort: Decodable {
    let id: String?
    let name: String?
}

struct AvailableSorts: Decodable {
    let sorts: [Sort]?
}

struct Filters: Decodable {
    let filter: [Filter]?
}

struct Filter: Decodable {
    let id: String?
    let name: String?
    let type: String?
}

struct AvailableFilters: Decodable {
    let filter: [Filter]?
}
