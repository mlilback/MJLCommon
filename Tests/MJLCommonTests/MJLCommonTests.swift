import XCTest
@testable import MJLCommon

class MJLCommonTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        XCTAssertEqual(MJLCommon().text, "Hello, World!")
    }


    static var allTests : [(String, (MJLCommonTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
