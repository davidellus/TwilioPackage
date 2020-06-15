import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TwilioPackageTests.allTests),
    ]
}
#endif
