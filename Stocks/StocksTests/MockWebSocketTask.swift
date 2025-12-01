//
//  MockWebSocketTask.swift
//  StocksTests
//
//  Created by Tihomir Ganev on 1.12.25.
//

@testable import Stocks

import Foundation
import Combine


final class MockWebSocketTask: WebSocketTasking {
    var state: URLSessionTask.State = .running
    private(set) var didResume = false
    private(set) var didCancel = false

    private(set) var sentMessages: [URLSessionWebSocketTask.Message] = []

    // Queue of messages to "receive"
    var receiveQueue: [Result<URLSessionWebSocketTask.Message, Error>] = []

    func resume() {
        didResume = true
        state = .running
    }
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        didCancel = true
        state = .completed
    }

    func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) {
        sentMessages.append(message)
        completionHandler(nil)
    }

    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) {
        guard !receiveQueue.isEmpty else { return }
        completionHandler(receiveQueue.removeFirst())
    }
}

struct MockSession: WebSocketSessioning {
    let task: MockWebSocketTask
    func webSocketTask(with url: URL) -> WebSocketTasking { task }
}

struct ImmediateTimerScheduler: TimerScheduling {
    func scheduledTimer(interval: TimeInterval, repeats: Bool, _ block: @escaping () -> Void) -> AnyCancellable {
        // no-op for unit tests (you can manually call updateAssetsPrices)
        AnyCancellable {}
    }
}

final class FixedRandomizer: PriceRandomizing {
    let values: [Double]
    private var idx = 0
    init(values: [Double]) {
        self.values = values
    }
    func randomPrice() -> Double {
        defer { idx = (idx + 1) % values.count }
        return values[idx]
    }
}
