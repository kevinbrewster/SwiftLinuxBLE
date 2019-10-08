import XCTest
@testable import SwiftLinuxBLE

final class SwiftLinuxBLETests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftLinuxBLE().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
