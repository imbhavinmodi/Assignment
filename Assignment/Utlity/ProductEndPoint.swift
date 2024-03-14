//
//  ProductEndPoint.swift
//  Assignment
//
//  Created by Bhavin's on 14/03/24.
//

import Foundation

enum ProductEndPoint {
    case products
}

extension ProductEndPoint: EndPointType {

    var path: String {
        switch self {
        case .products:
            return "products"
        }
    }

    var baseURL: String {
        switch self {
        case .products:
            return "https://fakestoreapi.com/"
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .products:
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case .products:
            return nil
        }
    }

    var headers: [String : String]? {
        APIManager.commonHeaders
    }
}
