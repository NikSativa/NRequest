import Foundation

public protocol RequestStatePlugin {
    func willSend(_ parameters: Parameters,
                  request: URLRequestRepresentation,
                  userInfo: inout Parameters.UserInfo)
    func didReceive(_ parameters: Parameters,
                    request: URLRequestRepresentation,
                    data: RequestResult,
                    userInfo: inout Parameters.UserInfo)
}