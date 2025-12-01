# Stocks — Real-Time Price Tracker (SwiftUI + MVVM + Combine)

A small iOS app that displays real-time price updates for multiple stock symbols using a WebSocket echo server. The feed is updated every 2 seconds by sending random price messages for each symbol and consuming the echoed responses.

## Features

### Feed Screen
- Shows a scrollable list of **25 stock symbols** (AAPL, GOOG, TSLA, …).
- Each row displays:
  - Symbol
  - Current price
  - Price trend indicator (↑ green / ↓ red / → flat)
- List is **sorted by price (highest first)**.
- Tap a row to open the **Symbol Details** screen.
- Top bar:
  - Left: connection status (🟢 / 🔴)
  - Right: Start/Stop toggle

### Symbol Details Screen
- Shows the selected symbol as the title
- Displays current price and trend indicator
- Includes a short description per symbol

### WebSocket Integration
- Connects to: `wss://ws.postman-echo.com/raw`
- Every 2 seconds:
  - Generates random price updates for each symbol
  - Sends messages **sequentially**
  - Receives echoed messages
  - Updates the UI accordingly (single shared connection for the whole app)

## Architecture

- **SwiftUI** for UI (List/NavigationStack)
- **MVVM**:
  - `StockFeedService` is the single WebSocket/stream source.
  - ViewModels transform incoming messages into immutable UI state.
- **Combine**:
  - WebSocket messages are exposed as publishers (`AnyPublisher`)
  - ViewModels subscribe and update their published state.

### High-level data flow
1. Timer tick (every 2s)
2. Service sends N messages (one per symbol)
3. Echo server returns messages asynchronously
4. Service batches updates and publishes through `priceUpdatePublisher`
5. ViewModel updates rows (current + previous), sorts, and publishes UI state

## Project Structure (example)
- `Services/`
  - `StockFeedService.swift` — WebSocket + timer + batching + publishers
  - `AssetsListService.swift` — stock list + socket URL
- `Models/`
  - `StockPriceUpdate.swift` — Codable message DTO
  - `StockRowModel.swift` — UI model (current, previous, trend/flash)
- `ViewModels/`
  - `FeedViewModel.swift`
  - `SymbolDetailsViewModel.swift`
- `Views/`
  - `FeedView.swift`
  - `SymbolDetailsView.swift`
  - `PriceFeedToolbar.swift`
- `StocksTests/`
  - `StockFeedServiceTests.swift` (+ mocks)

> Names may differ slightly depending on your local project layout.

## Requirements
- Xcode 15+ (recommended)
- iOS 17+ (or adjust depending on your deployment target)
- Swift Concurrency (Tasks) + Combine

## Implementation Notes

- **No duplicate WebSocket connections**: the service is created once (composition root) and injected where needed.
- **Batching**: UI updates are emitted only when all expected messages for a cycle are received, so the feed doesn’t re-sort on every single echo.
- **Trend / previous price**: each row keeps `previousPrice` so the UI can show up/down/flat indicators.
- **Reusable components**: Top bar is reusable troughout the app.

## Future Improvements (optional)
- Flash: “flash” effect for 1 second after a change.
- Deep link: `stocks://symbol/{SYMBOL}`
- Performance tuning for larger symbol counts (e.g. 1000+)
- UI tests (XCTest + XCUITest)
