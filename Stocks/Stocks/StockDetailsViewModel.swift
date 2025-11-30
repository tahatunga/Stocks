//
//  StockDetailsViewModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import Combine

class StockDetailsViewModel: ObservableObject {
    
    @Published var stock: StockRowModel
    private var cancellables = Set<AnyCancellable>()
    private let stockFeedService: StockFeedService

    let desctipion: String
    
    init(stock: StockRowModel, feed: StockFeedService, assetsService: AssetsListService = AssetsListService()) {
        self.stockFeedService = feed
        self.stock = stock
        self.desctipion = assetsService.stockDescriptions[stock.stockName] ?? ""
        self.bindToStockPrice()
    }
    
    deinit {
        cancellables.removeAll()
    }

    private func bindToStockPrice() {
        stockFeedService.priceUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.handlePriceUpdate(message)
            }
            .store(in: &cancellables)
    }

    private func handlePriceUpdate(_ message: StockPriceUpdate) {
        guard message.stock == stock.stockName else { return }
        self.stock.previosPrice = self.stock.stockPrice
        stock.stockPrice = message.price
    }
}
