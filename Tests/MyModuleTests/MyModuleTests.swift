import MyModule
import XCTest

final class MyModuleTests: XCTestCase {
    func testSuccess() {
        // do nothing

        // temporarily fail just on macOS for testing.
        #if os(macOS) && swift(>=5.6)
        XCTFail()
        #endif
    }
}