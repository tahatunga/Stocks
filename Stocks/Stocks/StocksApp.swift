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
    @StateObject private var feedControlsViewModel: StockToolbarViewModel
    
    init() {
        let service = StockFeedService(assetsListService: AssetsListService())
        _stockFeedService = StateObject(wrappedValue: service)
        _feedControlsViewModel = StateObject(wrappedValue: StockToolbarViewModel(stockFeedService: service))
    }
    
    var body: some Scene {
        WindowGroup {
            StocksView(viewModel: StocksViewModel(service: stockFeedService, assets: AssetsListService()))
                .environmentObject(stockFeedService)
                .environmentObject(feedControlsViewModel)
        }
    }
}
