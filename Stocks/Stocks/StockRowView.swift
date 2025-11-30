//
//  StockRowView.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import SwiftUI

struct StockRowView: View {
    
    let viewModel: StockRowViewModel
    
    var body: some View {
        content
    }
}

extension StockRowView {
    private var content: some View {
        HStack {
            Text(viewModel.stock.stockName)
            Spacer()
            Text(String(format: "%.2f", viewModel.stock.stockPrice))
                .font(.caption)
        }
    }
}
#Preview {
    StockRowView(viewModel: StockRowViewModel(stock: StockRowModel(stockName: "AAPL", stockPrice: 250)))
}
