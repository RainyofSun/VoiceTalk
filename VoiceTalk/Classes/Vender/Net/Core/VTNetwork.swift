//
//  VTNetwork.swift
//  VoiceTalk
//
//  Created by 刘冉 on 2021/12/9.
//  Copyright © 2021 macos. All rights reserved.
//

/*
 使用指南
 https://www.jianshu.com/p/2ee5258828ff
 */

import Foundation
import Alamofire
import Moya

public typealias Success = (_ response: Moya.Response) -> Void
public typealias Failure = (_ error: VTNetworkError) -> Void
public typealias JsonSuccess = (_ response:Any) ->Void

public struct VTNetworking<T: VTServerType> {
    public let provider: MoyaProvider<T>
    public init(provider: MoyaProvider<T> = newDefaultProvider()) {
        self.provider = provider
    }
}

extension VTNetworking {
    @discardableResult
    public func requestJson(_ target: T,
                            callbackQueue:DispatchQueue? = DispatchQueue.main,
                            progress: ProgressBlock? = .none,
                            success:@escaping JsonSuccess,
                            failure:@escaping Failure) -> Cancellable {
        return self.request(target, callbackQueue: callbackQueue, progress: progress) { response in
            do {
                let json = try handleNetResponse(response)
                success(json)
            } catch (let error) {
                failure(error as! VTNetworkError)
            }
        } failure: { error in
            failure(error)
        }

    }
    
    @discardableResult
    public func request(_ target:T,
                        callbackQueue:DispatchQueue? = DispatchQueue.main,
                        progress:ProgressBlock? = .none,
                        success:@escaping Success,
                        failure:@escaping Failure) -> Cancellable {
        return self.provider.requestNormal(target, callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case let .success(response):
                success(response)
            case let .failure(error):
                failure(VTNetworkError.init(error: error))
                break
            }
        }
    }
}

extension VTNetworking {
    public static func newDefaultProvider() -> MoyaProvider<T> {
        return newProvider(plugins: plugins)
    }
    
    /*
     EndpointClosure = (Target) -> Endpoint就是定义如何将 Targets 映射为Endpoints `
     在这个闭包中，你可以改变task，method，url, headers 或者 sampleResponse。比如，我们可能希望将应用程序名称设置到HTTP头字段中，从而用于服务器端分析
     */
    static func endpointsClosure<T>() -> (T) -> Endpoint where T: VTServerType {
        return { target in
            let defaultEndpoint = Endpoint(
                url: URL(target: target).absoluteString,
                sampleResponseClosure: { target.sampleResponse },
                method: target.method,
                task: target.task,
                httpHeaderFields: target.headers
            )
            return defaultEndpoint;
        }
    }
    
    /*
     RequestClosure = (Endpoint, @escaping RequestResultClosure) -> Void 就是 Endpoint 转换为 Request的一个拦截，它还可以修改请求的结果( 通过调用RequestResultClosure = (Result<URLRequest, MoyaError>) )
     */
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                request.timeoutInterval = VTServer.shared.timeOutInterval
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
    
    /*
     提供一个stubClosure。这个闭包返回 .never (默认的), .immediate 或者可以把stub请求延迟指定时间的.delayed(seconds)三个中的一个。 例如, .delayed(0.2) 可以把每个stub 请求延迟0.2s. 这个在单元测试中来模拟网络请求是非常有用的。
     */
    static func APIKeysBasedStubBehaviour<T>(_ target: T) -> Moya.StubBehavior where T: VTServerType {
        return target.stubBehavior;
    }
    
    static var plugins: [PluginType] {
        let activityPlugin = VTNetworkActivityPlugin { (state, targetType) in
            switch state {
            case .began:
                if targetType.showLoading { //这是我扩展的协议
                    // 显示loading
                }
            case .ended:
                if targetType.showLoading { //这是我扩展的协议
                    // 关闭loading
                }
            }
        }
        return [
            activityPlugin, myLoggorPlugin
        ]
    }
}

// Provider 将 Targets 映射成 Endpoints, 然后再将 Endpoints 映射成真正的 Request。
func newProvider<T>(plugins: [PluginType], manager: Session = Session()) -> MoyaProvider<T> where T: VTServerType {
    return MoyaProvider(endpointClosure: VTNetworking<T>.endpointsClosure(),
                        requestClosure: VTNetworking<T>.endpointResolver(),
                        stubClosure: VTNetworking<T>.APIKeysBasedStubBehaviour,
                        callbackQueue: DispatchQueue.main,
                        session: manager,
                        plugins: plugins,
                        trackInflights: false)
}

func newSession(delegate: SessionDelegate = SessionDelegate(),
                serverTrustPolicyManager: ServerTrustManager? = nil) -> Session {
    // Given
    let configuration = URLSessionConfiguration.af.default
    configuration.headers = HTTPHeaders.default
    let delegate = SessionDelegate()
    let serverTrustManager = ServerTrustManager(evaluators: [:])

    // When
    let session = Session(configuration: configuration,
                          delegate: delegate,
                          startRequestsImmediately: false,
                          serverTrustManager: serverTrustManager)
    
    return session
}
