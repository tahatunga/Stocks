//
//  StocksViewModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import Combine

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
            .sink { [weak self] message in
                self?.handlePriceUpdate(message)
            }
            .store(in: &cancellables)
    }

    private func handlePriceUpdate(_ message: StockPriceUpdate) {
        if let index = stocks.firstIndex(where: { $0.stockName == message.stock }),
           stocks[index].timestamp ?? 0.0 < message.timestamp { // ensure the update will be with newer value
            stocks[index].previosPrice = stocks[index].stockPrice
            stocks[index].stockPrice = message.price
            // The following can be optimised in many ways
            self.stocks = stocks.sorted {
                $0.stockPrice > $1.stockPrice
            }
        }
    }
}
