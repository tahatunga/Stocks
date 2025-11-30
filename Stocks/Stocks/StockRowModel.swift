//
//  StockRowModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import UIKit

enum Trend: Equatable { case up, down, flat }
extension Trend {
    func symbol() -> String {
        switch self {
        case .up: return "arrow.up.right"
        case .down: return "arrow.down.right"
        case .flat: return "minus"
        }
    }
}

struct StockRowModel: Hashable {
    
    let stockName: String
    var stockPrice: Double
    var previosPrice: Double?
    var timestamp: TimeInterval?
    var flash: Bool = false
    var trend: Trend {
        guard let previosPrice else { return .flat }
                if stockPrice > previosPrice { return .up }
                if stockPrice < previosPrice { return .down }
                return .flat
    }
    
    var textColor: UIColor {
        switch trend {
        case .up: return .systemGreen
        case .down: return .systemRed
        case .flat: return .label
        }
    }
}
