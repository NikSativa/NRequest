import Foundation

public struct Parameters {
    public enum TaskKind {
        case download(progressHandler: ProgressHandler?)
        case upload(progressHandler: ProgressHandler?)
    }

    public struct CacheSettings: Equatable {
        public let cache: URLCache
        public let storagePolicy: URLCache.StoragePolicy

        public init(cache: URLCache,
                    storagePolicy: URLCache.StoragePolicy = .allowedInMemoryOnly) {
            self.cache = cache
            self.storagePolicy = storagePolicy
        }
    }

    public let address: Address
    public let header: [String: String]
    public let method: HTTPMethod
    public let body: Body
    public let timeoutInterval: TimeInterval
    public let cacheSettings: CacheSettings?
    public let requestPolicy: URLRequest.CachePolicy
    public let queue: ResponseQueue
    public let plugins: [Plugin]
    public let isLoggingEnabled: Bool
    public let taskKind: TaskKind

    public init(address: Address,
                header: [String: String] = [:],
                method: HTTPMethod = .get,
                body: Body = .empty,
                plugins: [Plugin] = [],
                cacheSettings: CacheSettings? = nil,
                requestPolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
                timeoutInterval: TimeInterval = 60,
                queue: ResponseQueue = DispatchQueue.main,
                isLoggingEnabled: Bool = false,
                taskKind: TaskKind = .download(progressHandler: nil)) {
        self.address = address
        self.header = header
        self.method = method
        self.body = body
        self.plugins = plugins
        self.timeoutInterval = timeoutInterval
        self.cacheSettings = cacheSettings
        self.requestPolicy = requestPolicy
        self.queue = queue
        self.isLoggingEnabled = isLoggingEnabled
        self.taskKind = taskKind
    }

    private init(_ original: Parameters, plugins: [Plugin]) {
        self.address = original.address
        self.header = original.header
        self.method = original.method
        self.body = original.body
        self.plugins = plugins
        self.timeoutInterval = original.timeoutInterval
        self.cacheSettings = original.cacheSettings
        self.requestPolicy = original.requestPolicy
        self.queue = original.queue
        self.isLoggingEnabled = original.isLoggingEnabled
        self.taskKind = original.taskKind
    }
}

extension Parameters {
    public static func + (lhs: Parameters, plugin: Plugin) -> Parameters {
        return Parameters(lhs, plugins: lhs.plugins + [plugin])
    }

    public static func + (lhs: Parameters, plugin: [Plugin]) -> Parameters {
        return Parameters(lhs, plugins: lhs.plugins + plugin)
    }
}
