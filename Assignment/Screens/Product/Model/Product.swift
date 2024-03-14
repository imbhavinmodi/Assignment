//
//  Product.swift
//  Assignment
//
//  Created by Bhavin's on 14/03/24.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: URL?
    let rating: Rate
}

struct Rate: Codable {
    let rate: Double
    let count: Int
}
