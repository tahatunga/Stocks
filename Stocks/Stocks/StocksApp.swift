//
//  StocksApp.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import SwiftUI

@main
struct StocksApp: App {
    
    @StateObject private var stockFeedService: StockFeedService
    @StateObject private var feedControlsViewModel: StockToolbarViewModel // This could be reused trough the app for the top bar
    
    init() {
        let stockFeedService = StockFeedService(assetsListService: AssetsListService())
        _stockFeedService = StateObject(wrappedValue: stockFeedService)
        _feedControlsViewModel = StateObject(wrappedValue: StockToolbarViewModel(stockFeedService: stockFeedService))
    }
    
    var body: some Scene {
        WindowGroup {
            StocksView(viewModel: StocksViewModel(service: stockFeedService, assets: AssetsListService()))
                .environmentObject(stockFeedService)
                .environmentObject(feedControlsViewModel)
        }
    }
}
