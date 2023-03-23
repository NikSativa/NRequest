import Foundation
import Nimble
import NSpry
import Quick

@testable import NRequest
@testable import NRequestTestHelpers

final class ParametersSpec: QuickSpec {
    override func spec() {
        describe("Parameters") {
            var subject: Parameters!
            var originalPlugin: FakeRequestStatePlugin!

            beforeEach {
                originalPlugin = .init()
                subject = .init(address: .url(.testMake()),
                                plugins: [originalPlugin])
            }

            describe("add 1 plugin") {
                var plugin: FakeRequestStatePlugin!
                var actual: Parameters!

                beforeEach {
                    plugin = .init()
                    actual = subject + plugin
                }

                it("should create new instance") {
                    expect(actual).toNot(equal(subject))
                }

                it("should add plugin") {
                    expect(compare(subject.plugins, [originalPlugin])).to(beTrue())
                    expect(compare(actual.plugins, [originalPlugin, plugin])).to(beTrue())
                }
            }

            describe("add array of plugin") {
                var plugins: [FakeRequestStatePlugin]!
                var actual: Parameters!

                beforeEach {
                    plugins = .init(repeating: .init(), count: 4)
                    actual = subject + plugins
                }

                it("should create new instance") {
                    expect(actual).toNot(equal(subject))
                }

                it("should add plugin") {
                    expect(compare(subject.plugins, [originalPlugin])).to(beTrue())
                    expect(compare(actual.plugins, [originalPlugin] + plugins)).to(beTrue())
                }
            }
        }
    }
}

private func compare(_ lhs: [RequestStatePlugin], _ rhs: [FakeRequestStatePlugin]) -> Bool {
    let zipped = zip(lhs.map { $0 as? FakeRequestStatePlugin }, rhs).map { $0 === $1 }
    return lhs.count == rhs.count && zipped.reduce(true) { $0 && $1 }
}
