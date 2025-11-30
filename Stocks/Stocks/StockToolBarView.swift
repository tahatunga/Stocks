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
                Text("Start")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .cornerRadius(8)
            }
        }
        .sharedBackgroundVisibility(SwiftUICore.Visibility.hidden)

    }
}
