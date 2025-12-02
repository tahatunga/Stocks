//
//  StocksViewModel.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import Combine
import SwiftUI

typealias StockName = String

@MainActor
public final class StocksViewModel: ObservableObject {
    
    private let stockFeedService: StockFeedServiceProtocol
    private let assets: AssetsListService // TODO: remove tide coupling
    private var cancellables = Set<AnyCancellable>()
    private var priceUpdateTask: Task<Void, Never>?

    @Published private(set) var stocks: [StockRowModel]
    @Published var navigationPath = NavigationPath()

    init(service: StockFeedServiceProtocol, assets: AssetsListService) {
        self.stockFeedService = service
        self.assets = assets
        let stocks = assets.stocks.map {
            StockRowModel(stockName: $0, stockPrice: 0)
        }
        self.stocks = stocks
        setupBindings()
    }
    
    deinit {
        cancellables.removeAll()
        priceUpdateTask?.cancel()
    }

    func handleIncomingURL(_ url: URL) {
        guard url.scheme == "stocks" else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }
        guard let action = components.host, action == "symbol" else { return }
        
        let stockName = String(components.path.dropFirst())
        if let stockForNavigation = stockForNavigation(for: stockName) {
            navigationPath.append(stockForNavigation)
        }
    }
    
    func stockForNavigation(for stockName: StockName) -> StockRowModel? {
        guard let stock = stocks.first(where: { $0.stockName == stockName }) else {
            return nil
        }
        
        return stock
    }
    
    private func setupBindings() {
        stockFeedService.priceUpdatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] batchUpdates in
                self?.handlePriceUpdate(batchUpdates)
            }
            .store(in: &cancellables)
    }

    // TODO: The models can be extracted to Factory / Builder + Mapper
    private func handlePriceUpdate(_ batchUpdates: [StockPriceUpdate]) {

        priceUpdateTask?.cancel()
        
        let currentStocks = self.stocks
        
        // Using detached task to be able to easily scale to more assets
        // TODO: - Add ordering / cancellation of the detached task to prevent from incorrect update urder
        Task.detached(priority: .userInitiated) { [currentStocks] in
            
            guard !Task.isCancelled else { return }
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
            guard !Task.isCancelled else { return }
            await MainActor.run {
                self.stocks = sortedModels
                self.resetFlashAfterDelay()
            }
        }
    }
    
    private func sortStocksByPrice(updatedStockPrices: [StockPriceUpdate]) -> [StockPriceUpdate] {
        return updatedStockPrices.sorted { $0.price > $1.price }
    }
    
    @MainActor
    private func resetFlashAfterDelay() {
        
        let currentStocks = self.stocks
        
        Task { [weak self] in
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            guard let self else { return }
            var noFlasingStocks: [StockRowModel] = []
            for var stock in currentStocks {
                stock.flash = false
                noFlasingStocks.append(stock)
            }
            self.stocks = noFlasingStocks
        }
    }
}
