//
//  StockFeedService+TestHelpers.swift
//  Stocks
//
//  Created by Tihomir Ganev on 2.12.25.
//

#if DEBUG

import Foundation

extension StockFeedService {
    @MainActor
    func performTestTick_sendUpdatesOnce() async {
        await updateAssetsPrices()
    }
}
#endif // DEBUG
