//
//  StockToolBarView.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import SwiftUI

struct StockToolBarView: ToolbarContent {
    
    @ObservedObject var viewModel: StockToolbarViewModel
    
    var body: some ToolbarContent {

        ToolbarItem(placement: .navigationBarLeading) {
            HStack(spacing: 6) {
                Text(viewModel.isConnected ? "🟢" : "🔴")
                    .font(.system(size: 12))
                    .glassEffect()
            }
        }
        .sharedBackgroundVisibility(SwiftUICore.Visibility.hidden)

        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                viewModel.toggleConnection()
            }) {
                Text(viewModel.isConnected ? "Stop" : "Start")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(viewModel.isConnected ? Color.red : Color.green)
                    .cornerRadius(8)
            }
        }
        .sharedBackgroundVisibility(SwiftUICore.Visibility.hidden)
    }
}
