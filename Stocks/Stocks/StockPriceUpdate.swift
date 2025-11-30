//
//  StockPriceUpdate.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation


struct StockPriceUpdate: Codable {
    let stock: String
    var price: Double
    var timestamp: TimeInterval
}
