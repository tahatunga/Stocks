//
//  StockDetailsView.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import SwiftUI

struct StockDetailsView: View {
    
    @StateObject private var viewModel: StockDetailsViewModel
    
    init(viewModel: StockDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        content
    }
}

extension StockDetailsView {
    private var content: some View {
        ScrollView {
            Divider()
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 4) {
                    Text(String(format: "%.2f", viewModel.stock.stockPrice))
                        .foregroundStyle(Color(viewModel.stock.textColor))
                        .font(.system(size: 36, weight: .semibold))
                    Image(systemName: viewModel.stock.trend.symbol())
                        .font(.caption)
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                Text(viewModel.desctipion)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(viewModel.stock.stockName)
        .navigationBarTitleDisplayMode(.inline)
        .padding(20)
    }
}

#Preview {
    let stockFeedService = StockFeedService(assetsListService: AssetsListService())
    let feedControlsViewModel = StockToolbarViewModel(stockFeedService: stockFeedService)
    let viewModel = StockDetailsViewModel(stock: StockRowModel(stockName: "Stock", stockPrice: 10.0), feed: stockFeedService)
    StockDetailsView(viewModel: viewModel)
}
