import MyModule
import XCTest

final class MyModuleTests: XCTestCase {
    func testSuccess() {
        // do nothing

        // TODO: Temporarily not failing again!
        // temporarily fail just on macOS for testing.
        #if os(macOS) && swift(>=5.6)
        // XCTFail()
        #endif
    }
}