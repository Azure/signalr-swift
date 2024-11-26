import Foundation
import XCTest
@testable import SignalRClient

class MockConnection: ConnectionProtocol, @unchecked Sendable {
    var onReceive: Transport.OnReceiveHandler?
    var onClose: Transport.OnCloseHander?
    var onSend: ((StringOrData) -> Void)?

    private(set) var startCalled = false
    private(set) var sendCalled = false
    private(set) var stopCalled = false
    private(set) var sentData: StringOrData?

    func start(transferFormat: TransferFormat) async throws {
        startCalled = true
    }

    func send(_ data: StringOrData) async throws {
        sendCalled = true
        sentData = data
        onSend?(data)
    }

    func stop(error: Error?) async {
        stopCalled = true
    }
}

final class HubConnectionTests: XCTestCase {
    var mockConnection: MockConnection!
    var logger: Logger!
    var hubProtocol: HubProtocol!
    var hubConnection: HubConnection!

    override func setUp() async throws {
        mockConnection = MockConnection()
        logger = DefaultLogger()
        hubProtocol = JsonHubProtocol()
        hubConnection = HubConnection(
            connection: mockConnection,
            logger: logger,
            hubProtocol: hubProtocol,
            serverTimeout: nil,
            keepAliveInterval: nil
        )
    }

    func testStart_CallsStartOnConnection() async throws {
        // Act
        let expectation = XCTestExpectation(description: "send() should be called")

        mockConnection.onSend = { data in
            expectation.fulfill()
        }

        let task = Task {
            try await hubConnection.start()
        }

        // HubConnect start handshake
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Response a handshake response
        let handshakeResponse = """
        {}\u{1e}
        """
        await hubConnection.processIncomingData(.string(handshakeResponse))

        await whenTaskWithTimeout({ try await task.value }, timeout: 1.0) 
        // Assert
        let state = await hubConnection.state()
        XCTAssertEqual(HubConnectionState.Connected, state)
    }

    func testStart_FailedHandshake() async throws {
        // Act
        let expectation = XCTestExpectation(description: "send() should be called")

        mockConnection.onSend = { data in
            expectation.fulfill()
        }

        let task = Task {
            try await hubConnection.start()
        }

        // HubConnect start handshake
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Response a handshake response
        let handshakeResponse = """
        {"error": "Sample error"}\u{1e}
        """
        await hubConnection.processIncomingData(.string(handshakeResponse))

        _ = await whenTaskThrowsTimeout({ try await task.value }, timeout: 1.0) 
        // Assert
        let state = await hubConnection.state()
        XCTAssertEqual(HubConnectionState.Disconnected, state)
    }

    func testStart_ConnectionCloseRightAfterHandshake() async throws {
        // Act
        let expectation = XCTestExpectation(description: "send() should be called")

        mockConnection.onSend = { data in
            expectation.fulfill()
        }

        let task = Task {
            try await hubConnection.start()
        }

        // HubConnect start handshake
        await fulfillment(of: [expectation], timeout: 1.0)
        
        // Response a handshake response
        let handshakeResponse = """
        {}\u{1e}
        """

        // Close connection first
        await mockConnection.onClose?(nil)
        await hubConnection.processIncomingData(.string(handshakeResponse))

        let err = await whenTaskThrowsTimeout({ try await task.value }, timeout: 1.0)

        // Assert
        XCTAssertEqual(SignalRError.connectionAborted, err as? SignalRError)
        let state = await hubConnection.state()
        XCTAssertEqual(HubConnectionState.Disconnected, state)
    }

    func testStart_DuplicateStart() async throws {
        // Act
        let expectation = XCTestExpectation(description: "send() should be called")

        mockConnection.onSend = { data in
            expectation.fulfill()
        }

        let task = Task {
            try await hubConnection.start()
        }

        defer {task.cancel()}

        // HubConnect start handshake
        await fulfillment(of: [expectation], timeout: 1.0)

        do {
            try await hubConnection.start()
        } catch {
            XCTAssertEqual(SignalRError.duplicatedStart, error as? SignalRError)
        }
    }

    func whenTaskWithTimeout(_ task: @escaping () async throws -> Void, timeout: TimeInterval) async -> Void {
        let expectation = XCTestExpectation(description: "Task should complete")
        let wrappedTask = Task {
            _ = try await task()
            expectation.fulfill()
        }
        defer { wrappedTask.cancel() }

        await fulfillment(of: [expectation], timeout: timeout)
    }

    func whenTaskThrowsTimeout(_ task: @escaping () async throws -> Void, timeout: TimeInterval) async -> Error? {
        var returnErr: Error?
        let expectation = XCTestExpectation(description: "Task should throw")
        let wrappedTask = Task {
            do {
                _ = try await task()
            } catch {
                returnErr = error
                expectation.fulfill()
            }
        }
        defer { wrappedTask.cancel() }

        await fulfillment(of: [expectation], timeout: timeout)
        return returnErr
    }
}

