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
    
    @State var stocks = AssetsListService().stocks.map {
        StockRowModel(stockName: $0, stockPrice: 0)
    }
    
    var body: some View {
        content
    }
}

extension StocksView {
    private var content: some View {
        Group {
            NavigationStack(path: $navigationPath) {
                List(stocks, id: \.self) { stock in
                    NavigationLink(destination: StockDetailsView()) {
                        StockRowView(viewModel: StockRowViewModel(stock: stock))
                    }
                }
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
    StocksView()
        .environmentObject(stockFeedService)
        .environmentObject(feedControlsViewModel)
}
