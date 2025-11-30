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
    private var socket: URLSessionWebSocketTask?
    private var updateTimer: Timer?
    
    @Published private(set) var isConnected: Bool = false {
        didSet {
            print(isConnected)
        }
    }
    
    init(assetsListService: AssetsListService) {
        self.assetsListService = assetsListService
    }

    deinit {
        stopTimer()
    }

    private func updateAssetsPrices() {
        print("Tik")
    }
    
    private func startTimer() {
        updateTimer?.invalidate()
        
        updateTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            guard let self = self, self.isConnected else { return }
            self.updateAssetsPrices()
        }
        
        if let timer = updateTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func stopTimer() {
        updateTimer?.invalidate()
        updateTimer = nil
    }

    func toggleConnection() {
        if isConnected {
            disconnect()
            stopTimer()
        } else {
            connect()
            startTimer()
        }
    }
    
    private func connect() {
        guard socket == nil ||
              socket?.state == .canceling ||
              socket?.state == .completed else {
            return
        }
        
        socket = URLSession.shared.webSocketTask(with: assetsListService.url)
        socket?.resume()
        isConnected = true
        
    }
    
    private func disconnect() {
        socket?.cancel(with: .goingAway, reason: nil)
        socket = nil
        isConnected = false
    }
}
