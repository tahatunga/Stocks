//
//  StockRowModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation

struct StockRowModel: Hashable {
    
    let stockName: String
    var stockPrice: Double
    var previosPrice: Double?
}
