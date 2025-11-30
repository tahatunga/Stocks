//
//  ContentView.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import SwiftUI

struct StocksView: View {
    
    @State private var navigationPath = NavigationPath()
    
    @State var stocks = [
        "AAPL", "GOOG", "TSLA", "AMZN", "MSFT", "NVDA", "META", "NFLX",
        "DIS", "BABA", "V", "JPM", "WMT", "JNJ", "MA", "PG", "UNH",
        "HD", "PYPL", "INTC", "CMCSA", "VZ", "ADBE", "PFE", "BAC"
    ]
    
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
                        Text(stock)
                    }
                }
            }
        }
    }
}

#Preview {
    StocksView()
}
