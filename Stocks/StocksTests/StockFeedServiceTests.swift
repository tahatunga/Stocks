//
//  StockFeedServiceTests.swift
//  StocksTests
//
//  Created by Tihomir Ganev on 1.12.25.
//

import Foundation
import XCTest
import Combine
@testable import Stocks

@MainActor
final class StockFeedServiceTests: XCTestCase {
    private var bag = Set<AnyCancellable>()
    
    func testPublishesBatchOnlyAfterAllUpdatesArrive() {
        // Given
        let assets = AssetsListService(url: URL(string: "wss://ws.postman-echo.com/raw")!,
                                       stocks: ["AAPL", "GOOG", "TSLA"])
        let socket = MockWebSocketTask()
        let service = StockFeedService(assetsListService: assets,
                                       session: MockSession(task: socket),
                                       timer: ImmediateTimerScheduler(),
                                       randomizer: DefaultPriceRandomizer()
        )
        
        let exp = expectation(description: "Receives full batch")
        exp.assertForOverFulfill = true
        
        var received: [StockPriceUpdate] = []
        
        service.priceUpdatePublisher
            .sink { batch in
                received = batch
                exp.fulfill()
            }
            .store(in: &bag)
        
        // When: 2 messages -> no publish
        service.handleReceivedText(#"{"stock":"AAPL","price":10.0,"timestamp":1}"#)
        service.handleReceivedText(#"{"stock":"GOOG","price":20.0,"timestamp":2}"#)
        
        // Then: should NOT have fulfilled yet
        XCTAssertTrue(received.isEmpty)
        
        // When: 3rd message -> publish
        service.handleReceivedText(#"{"stock":"TSLA","price":30.0,"timestamp":3}"#)
        
        waitForExpectations(timeout: 1.0)
        XCTAssertEqual(received.count, 3)
        XCTAssertEqual(Set(received.map(\.stock)), Set(["AAPL","GOOG","TSLA"]))
    }
    
    func testToggleConnectionConnectsAndDisconnects() {
        let assets = AssetsListService(url: URL(string: "wss://ws.postman-echo.com/raw")!,
                                       stocks: ["AAPL", "GOOG", "TSLA"])
        let socket = MockWebSocketTask()
        let service = StockFeedService(assetsListService: assets,
                                       session: MockSession(task: socket),
                                       timer: ImmediateTimerScheduler())
        
        XCTAssertFalse(service.isConnected)
        service.toggleConnection()
        XCTAssertTrue(service.isConnected)
        
        service.toggleConnection()
        XCTAssertFalse(service.isConnected)
    }

}

