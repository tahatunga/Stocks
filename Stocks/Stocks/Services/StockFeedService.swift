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

func randomPrice() -> Double {
    round((Double.random(in: 10.0 ..< 300.0)) * 100) / 100
}

final class StockFeedService: ObservableObject {

    private let assetsListService: AssetsListService
    private let trackedStocks: [StockPriceUpdate]
    private var socket: URLSessionWebSocketTask?
    private var updateTimer: Timer?
    private let priceUpdateSubject = PassthroughSubject<StockPriceUpdate, Never>()
    
    var priceUpdatePublisher: AnyPublisher<StockPriceUpdate, Never> {
        priceUpdateSubject.eraseToAnyPublisher()
    }
    
    @Published private(set) var isConnected: Bool = false {
        didSet {
            print(isConnected)
        }
    }
    
    init(assetsListService: AssetsListService) {
        self.assetsListService = assetsListService
        self.trackedStocks = assetsListService.stocks.map {
            StockPriceUpdate(stock: $0, price: randomPrice(), timestamp: Date().timeIntervalSince1970)
        }
    }

    deinit {
        stopTimer()
    }
    
    private func updateAssetsPrices() {
        for var stock in trackedStocks {
            stock.price = randomPrice()
            stock.timestamp = Date().timeIntervalSince1970
            sendPriceUpdate(for: stock)
        }
    }
    
    private func sendPriceUpdate(for stock: StockPriceUpdate) {
        
        let encoder = JSONEncoder()
        guard isConnected else { return }
        guard let socket else { return }
        guard socket.state == .running else { return }
        guard let data = try? encoder.encode(stock) else { return }
        guard let stringData = String(data: data, encoding: .utf8) else { return }
        
        let message = URLSessionWebSocketTask.Message.string(stringData)

        socket.send(message) { error in
            if let error {
                //TODO:  Handle the error
                print("Error sending message: \(error)")
            }
        }
    }

    private func receivePriceUpdates() {
        guard let socket else { return }
        guard socket.state == .running else { return }
        socket.receive { [weak self] priceUpdate in
            guard let self = self else { return }
            
            switch priceUpdate {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.handleReceivedText(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.handleReceivedText(text)
                    }
                @unknown default:
                    break
                }
                
                // Continue receiving messages
                self.receivePriceUpdates()
                
            case .failure:
                DispatchQueue.main.async {
                    self.disconnect()
                    self.stopTimer()
                    self.isConnected = false
                }
            }
        }
    }

    private func handleReceivedText(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let update = try decoder.decode(StockPriceUpdate.self, from: data)
            DispatchQueue.main.async {
                self.priceUpdateSubject.send(update)
            }
        } catch {
        }
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
        receivePriceUpdates()
    }
    
    private func disconnect() {
        socket?.cancel(with: .goingAway, reason: nil)
        socket = nil
        isConnected = false
    }
}
