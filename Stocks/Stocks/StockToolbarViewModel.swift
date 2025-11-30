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
        self.isConnected = stockFeedService.isConnected
        setupBindings()
    }

    private func setupBindings() {
        stockFeedService.$isConnected
            .receive(on: DispatchQueue.main)
            .assign(to: &$isConnected)
    }

    func toggleConnection() {
        stockFeedService.toggleConnection()
    }
}
