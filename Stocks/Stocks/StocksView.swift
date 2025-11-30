//
//  ContentView.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import SwiftUI

struct StocksView: View {
    
    @EnvironmentObject var stockFeedService: StockFeedService
    @EnvironmentObject var feedControlsViewModel: StockToolbarViewModel
    
    @State private var navigationPath = NavigationPath()
    
    @StateObject private var viewModel: StocksViewModel
    
    init(viewModel: StocksViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
    }
}

extension StocksView {
    private var content: some View {
        Group {
            NavigationStack(path: $navigationPath) {
                List(viewModel.stocks, id: \.self) { stock in
                    NavigationLink(destination: StockDetailsView(viewModel: StockDetailsViewModel(stock: stock, feed: stockFeedService))) {
                        StockRowView(viewModel: StockRowViewModel(stock: stock))
                    }
                }
                .transaction { $0.animation = nil }
                .toolbar {
                    StockToolBarView(viewModel: feedControlsViewModel)
                }
            }
        }
    }
}

#Preview {
    
    let stockFeedService = StockFeedService(assetsListService: AssetsListService())
    let feedControlsViewModel = StockToolbarViewModel(stockFeedService: stockFeedService)
    StocksView(viewModel: StocksViewModel(service: stockFeedService, assets: AssetsListService()))
        .environmentObject(stockFeedService)
        .environmentObject(feedControlsViewModel)
}
