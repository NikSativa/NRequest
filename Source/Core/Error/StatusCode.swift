import Foundation

public enum StatusCode: Error, Equatable {
    case noContent       // 204
    case badRequest      // 400
    case unauthorized    // 401
    case notFound        // 404
    case timeout         // 408
    case upgradeRequired // 426
    case serverError     // 500
    case other(Int)
}

extension StatusCode {
    public func toInt() -> Int {
        switch self {
        case .noContent:
            return 204
        case .badRequest:
            return 400
        case .unauthorized:
            return 401
        case .notFound:
            return 404
        case .timeout:
            return 408
        case .upgradeRequired:
            return 426
        case .serverError:
            return 500
        case .other(let code):
            return code
        }
    }
}

extension StatusCode: ErrorMapping {
    public static func verify(_ code: Int?) throws {
        guard let code = code else {
            return
        }

        switch code {
        case 200:
            break
        case 204:
            throw noContent
        case 400:
            throw badRequest
        case 401:
            throw unauthorized
        case 404:
            throw notFound
        case 408:
            throw timeout
        case 426:
            throw upgradeRequired
        case 500:
            throw serverError
        default:
            throw other(code)
        }
    }
}
