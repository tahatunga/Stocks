//
//  StockFeedService.swift
//  Stocks
//
//  Created by Tihomir Ganev on 30.11.25.
//

import Foundation
import SwiftUI
import Combine

protocol StockFeedServiceProtocol {
    var isConnected: Bool { get }
    func toggleConnection()
}

final class StockFeedService: ObservableObject {

    @Published var isConnected: Bool = false
    
    func toggleConnection() {
        isConnected.toggle()
    }
}
