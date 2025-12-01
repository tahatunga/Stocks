//
//  StocksViewModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import Combine

typealias StockName = String

public final class StocksViewModel: ObservableObject {
    
    private let stockFeedService: StockFeedService
    private let assets: AssetsListService
    private var cancellables = Set<AnyCancellable>()

    @Published var stocks: [StockRowModel]
    
    init(service: StockFeedService, assets: AssetsListService) {
        self.stockFeedService = service
        self.assets = assets
        let stocks = assets.stocks.map {
            StockRowModel(stockName: $0, stockPrice: 0)
        }.sorted {
            $0.stockPrice > $1.stockPrice
        }
        self.stocks = stocks
        setupBindings()
    }
    
    deinit {
        cancellables.removeAll()
    }

    private func setupBindings() {
        stockFeedService.priceUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] batchUpdates in
                self?.handlePriceUpdate(batchUpdates)
            }
            .store(in: &cancellables)
    }

    private func handlePriceUpdate(_ batchUpdates: [StockPriceUpdate]) {

        let currentStocks = self.stocks
        Task.detached(priority: .low) { [currentStocks] in
            var rowModelsDictionary = Dictionary(uniqueKeysWithValues: currentStocks.map { ($0.stockName, $0) })
            for update in batchUpdates {
                if let oldStock = rowModelsDictionary[update.stock], oldStock.timestamp ?? 0 < update.timestamp {
                    let updatedStock = StockRowModel(stockName: update.stock, stockPrice: update.price, previosPrice: oldStock.stockPrice, timestamp: update.timestamp, flash: true)
                    rowModelsDictionary[update.stock] = updatedStock
                }
            }
            let sortedModels = rowModelsDictionary.values.sorted {
                if $0.stockPrice == $1.stockPrice { return $0.stockName < $1.stockName }
                return $0.stockPrice > $1.stockPrice
            }
            await MainActor.run { self.stocks = sortedModels }
        }
    }
    
    private func sortStocksByPrice(updatedStockPrices: [StockPriceUpdate]) -> [StockPriceUpdate] {
        return updatedStockPrices.sorted { $0.price > $1.price }
    }
    
}
