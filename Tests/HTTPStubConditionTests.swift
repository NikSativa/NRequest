import Foundation
import XCTest

@testable import NRequest
@testable import NRequestTestHelpers

final class HTTPStubTest_Tests: XCTestCase {
    private let request: URLRequest = {
        let parameter = Parameters.testMake(address: .testMake(scheme: .https,
                                                               host: "api.example.com",
                                                               path: ["signin", "v1.0"],
                                                               queryItems: ["user": "foo"]),
                                            method: .get,
                                            shouldAddSlashAfterEndpoint: true)
        let repr = try! parameter.urlRequestRepresentation()
        return repr.sdk
    }()

    func test_isPath() {
        XCTAssertTrue(HTTPStubCondition.isPath("/signin/v1.0").test(request))

        XCTAssertFalse(HTTPStubCondition.isPath("signin/v1.0").test(request))
        XCTAssertFalse(HTTPStubCondition.isPath("signin").test(request))
        XCTAssertFalse(HTTPStubCondition.isPath("signin/").test(request))
        XCTAssertFalse(HTTPStubCondition.isPath("/signin/").test(request))
        XCTAssertFalse(HTTPStubCondition.isPath("/signin/v1.0/").test(request))
    }

    func test_isHost() {
        XCTAssertTrue(HTTPStubCondition.isHost("api.example.com").test(request))
    }

    func test_isAbsoluteURLString() {
        XCTAssertTrue(HTTPStubCondition.isAbsoluteURLString("https://api.example.com/signin/v1.0/?user=foo").test(request))
    }

    func test_isMethod() {
        XCTAssertTrue(HTTPStubCondition.isMethod("GET").test(request))
        XCTAssertFalse(HTTPStubCondition.isMethod("POST").test(request))
    }

    func test_isScheme() {
        XCTAssertTrue(HTTPStubCondition.isScheme("https").test(request))
        XCTAssertFalse(HTTPStubCondition.isScheme("http").test(request))
    }

    func test_pathStartsWith() {
        XCTAssertTrue(HTTPStubCondition.pathStartsWith("/signin/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathStartsWith("/signin/v1.").test(request))
        XCTAssertTrue(HTTPStubCondition.pathStartsWith("/signin/v1").test(request))
        XCTAssertTrue(HTTPStubCondition.pathStartsWith("/signin/v").test(request))
        XCTAssertTrue(HTTPStubCondition.pathStartsWith("/signin/").test(request))
        XCTAssertTrue(HTTPStubCondition.pathStartsWith("/signin").test(request))
        XCTAssertTrue(HTTPStubCondition.pathStartsWith("/sign").test(request))
    }

    func test_pathEndsWith() {
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("/signin/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("signin/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("ignin/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("gnin/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("nin/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("n/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("/v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("v1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith("1.0").test(request))
        XCTAssertTrue(HTTPStubCondition.pathEndsWith(".0").test(request))
    }

    func test_pathNSMatches() throws {
        let regexStr = "/(.*)/v1.0"
        XCTAssertTrue(HTTPStubCondition.pathNSMatches(try .init(pattern: regexStr, options: [.caseInsensitive])).test(request))
        XCTAssertFalse(HTTPStubCondition.pathNSMatches(try .init(pattern: regexStr.replacingOccurrences(of: "v1", with: "v2"), options: [.caseInsensitive])).test(request))
    }

    @available(iOS 16.0, *)
    func test_pathMatches() throws {
        let regexStr = "/(.*)/v1.0"
        XCTAssertTrue(HTTPStubCondition.pathMatches(try .init(regexStr)).test(request))
        XCTAssertFalse(HTTPStubCondition.pathMatches(try .init(regexStr.replacingOccurrences(of: "v1", with: "v2"))).test(request))
    }

    func test_absoluteStringNSMatches() throws {
        let regexStr = "(.*)example.com/(.*)/v1.0/(.*)"
        XCTAssertTrue(HTTPStubCondition.absoluteStringNSMatches(try .init(pattern: regexStr, options: [.caseInsensitive])).test(request))
        XCTAssertFalse(HTTPStubCondition.absoluteStringNSMatches(try .init(pattern: regexStr.replacingOccurrences(of: "v1", with: "v2"), options: [.caseInsensitive])).test(request))
    }

    @available(iOS 16.0, *)
    func test_absoluteStringMatches() throws {
        let regexStr = "(.*)example.com/(.*)/v1.0/(.*)"
        XCTAssertTrue(HTTPStubCondition.absoluteStringMatches(try .init(regexStr)).test(request))
        XCTAssertFalse(HTTPStubCondition.absoluteStringMatches(try .init(regexStr.replacingOccurrences(of: "v1", with: "v2"))).test(request))
    }
}