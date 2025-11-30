//
//  StocksViewModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import Combine

public final class StocksViewModel: ObservableObject {
    
    private let service: StockFeedService
    private let assets: AssetsListService

    @Published var stocks: [StockRowModel]
    
    init(service: StockFeedService, assets: AssetsListService) {
        self.service = service
        self.assets = assets
        self.stocks = assets.stocks.map {
            StockRowModel(stockName: $0, stockPrice: 0)
        }
    }
}
