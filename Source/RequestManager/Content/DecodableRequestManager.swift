import Foundation
import NQueue

public protocol DecodableRequestManager {
    func request<T: Decodable>(_ type: T.Type,
                               address: Address,
                               with parameters: Parameters,
                               inQueue completionQueue: DelayedQueue,
                               completion: @escaping (Result<T, Error>) -> Void) -> RequestingTask
    func request<T: Decodable>(opt type: T.Type,
                               address: Address,
                               with parameters: Parameters,
                               inQueue completionQueue: DelayedQueue,
                               completion: @escaping (Result<T?, Error>) -> Void) -> RequestingTask
}

public extension DecodableRequestManager {
    func request<T: Decodable>(_ type: T.Type,
                               address: Address,
                               with parameters: Parameters = .init(),
                               inQueue completionQueue: DelayedQueue = RequestSettings.defaultResponseQueue,
                               completion: @escaping (Result<T, Error>) -> Void) -> RequestingTask {
        return request(type,
                       address: address,
                       with: parameters,
                       inQueue: completionQueue,
                       completion: completion)
    }

    func request<T: Decodable>(opt type: T.Type,
                               address: Address,
                               with parameters: Parameters = .init(),
                               inQueue completionQueue: DelayedQueue = RequestSettings.defaultResponseQueue,
                               completion: @escaping (Result<T?, Error>) -> Void) -> RequestingTask {
        return request(opt: type,
                       address: address,
                       with: parameters,
                       inQueue: completionQueue,
                       completion: completion)
    }

    // MARK: - async

    func request<T: Decodable>(_ type: T.Type,
                               address: Address,
                               with parameters: Parameters = .init(),
                               inQueue completionQueue: DelayedQueue = RequestSettings.defaultResponseQueue) async -> Result<T, Error> {
        return await withCheckedContinuation { [self] completion in
            let task = request(type,
                               address: address,
                               with: parameters,
                               inQueue: completionQueue) { data in
                completion.resume(returning: data)
            }
            task.start()
        }
    }

    func request<T: Decodable>(opt type: T.Type,
                               address: Address,
                               with parameters: Parameters = .init(),
                               inQueue completionQueue: DelayedQueue = RequestSettings.defaultResponseQueue) async -> Result<T?, Error> {
        return await withCheckedContinuation { [self] completion in
            let task = request(opt: type,
                               address: address,
                               with: parameters,
                               inQueue: completionQueue) { data in
                completion.resume(returning: data)
            }
            task.start()
        }
    }

    // MARK: - async throws

    func request<T: Decodable>(_ type: T.Type,
                               address: Address,
                               with parameters: Parameters,
                               inQueue completionQueue: DelayedQueue) async throws -> T {
        return try await withCheckedThrowingContinuation { [self] completion in
            let task = request(type,
                               address: address,
                               with: parameters,
                               inQueue: completionQueue) { data in
                completion.resume(with: data)
            }
            task.start()
        }
    }

    func request<T: Decodable>(opt type: T.Type,
                               address: Address,
                               with parameters: Parameters,
                               inQueue completionQueue: DelayedQueue) async throws -> T? {
        return try await withCheckedThrowingContinuation { [self] completion in
            let task = request(opt: type,
                               address: address,
                               with: parameters,
                               inQueue: completionQueue) { data in
                completion.resume(with: data)
            }
            task.start()
        }
    }
}
