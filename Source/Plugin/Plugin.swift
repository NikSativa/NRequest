import Foundation


public protocol Plugin {
    func prepare(_ parameters: Parameters,
                 request: inout URLRequestable,
                 userInfo: inout Parameters.UserInfo)

    func willSend(_ parameters: Parameters,
                  request: URLRequestable,
                  userInfo: inout Parameters.UserInfo)
    func didReceive(_ parameters: Parameters,
                    data: ResponseData,
                    userInfo: inout Parameters.UserInfo)
    func didFinish(_ parameters: Parameters,
                   data: ResponseData,
                   userInfo: inout Parameters.UserInfo,
                   dto: Any?)

    func verify(data: ResponseData,
                userInfo: inout Parameters.UserInfo) throws
}
