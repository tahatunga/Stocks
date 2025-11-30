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

final class AssetsListService {
    let url = URL(string: "wss://ws.postman-echo.com/raw")!
    let stocks = [
        "AAPL", "GOOG", "TSLA", "AMZN", "MSFT", "NVDA", "META", "NFLX",
        "DIS", "BABA", "V", "JPM", "WMT", "JNJ", "MA", "PG", "UNH",
        "HD", "PYPL", "INTC", "CMCSA", "VZ", "ADBE", "PFE", "BAC"
    ]
}

final class StockFeedService: ObservableObject {

    private let assetsListService: AssetsListService
    private var webSocketTask: URLSessionWebSocketTask?
    
    @Published private(set) var isConnected: Bool = false {
        didSet {
            print(isConnected)
        }
    }
    
    init(assetsListService: AssetsListService) {
        self.assetsListService = assetsListService
    }

    func toggleConnection() {
        if isConnected {
            disconnect()
        } else {
            connect()
        }
    }
    
    private func connect() {
        guard webSocketTask == nil ||
              webSocketTask?.state == .canceling ||
              webSocketTask?.state == .completed else {
            return
        }
        
        webSocketTask = URLSession.shared.webSocketTask(with: assetsListService.url)
        webSocketTask?.resume()
        isConnected = true
        
    }
    
    private func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        isConnected = false
    }
}
