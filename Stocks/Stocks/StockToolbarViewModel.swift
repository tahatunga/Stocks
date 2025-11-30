//
//  StockToolbarViewModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import Combine

class StockToolbarViewModel: ObservableObject {
    
    @Published private(set) var isConnected: Bool = false
    
    private let stockFeedService: StockFeedService
    
    init(stockFeedService: StockFeedService) {
        self.stockFeedService = stockFeedService
    }

    func toggleConnection() {
        stockFeedService.toggleConnection()
    }
}
