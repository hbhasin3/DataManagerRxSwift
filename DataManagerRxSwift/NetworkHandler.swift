import RxSwift

public let k_DEFAULT_REQUEST_TIMEOUT = 180.0
public let k_DEFAULT_RESOURCE_TIMEOUT = 180.0

class NetworkHandler {
    
    fileprivate enum ApiError: Error {
        case DataNotFound
        case serverFailure
    }
    
    private func send<T: Decodable>(apiRequest: RequestModel) -> Single<T> {
        
        return Observable<T>.create { observer in
            let request = apiRequest.request()
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                guard let data = data, error == nil else {
                    
                    observer.onError(error!)
                    print(error?.localizedDescription ?? "No Data")
                    return
                }
                
                do {
                    if let httpResponse = response as? HTTPURLResponse {
                        if 200 ..< 300 ~= httpResponse.statusCode {
                            let model: T = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(model)
                        } else if 400 ..< 500 ~= httpResponse.statusCode {
                            throw ApiError.DataNotFound
                        } else {
                            throw ApiError.serverFailure
                        }
                    }
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
            }
            .take(1)
            .asSingle()
    }
    
    private func sender<T: Decodable>(apiRequest: RequestModel) -> Single<T> {
        return Single<T>.create { single in
            
            self.debugPrintRequest(apiRequest: apiRequest)
            
            let disposable = Disposables.create()
            let request = apiRequest.request()
            
            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
            sessionConfig.timeoutIntervalForRequest = k_DEFAULT_REQUEST_TIMEOUT
            sessionConfig.timeoutIntervalForResource = k_DEFAULT_RESOURCE_TIMEOUT
            let session = URLSession(configuration: sessionConfig)
//            let session = URLSession(configuration: sessionConfig, delegate: URLSessionPinningDelegate(), delegateQueue: nil)
            defer {
                session.finishTasksAndInvalidate()
            }
            
            let task = session.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    single(.error(error!))
                    return
                }
                
                do {
                    if let httpResponse = response as? HTTPURLResponse {
                        if 200 ..< 300 ~= httpResponse.statusCode {
                            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                            self.debugPrintResponse(Type: T.self, dict: responseJSON as? [String:Any] ?? [:])
                            let model: T = try JSONDecoder().decode(T.self, from: data)
                            single(.success(model))
                            
                        } else {
                            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                            self.debugPrintResponse(Type: T.self, dict: responseJSON as? [String:Any] ?? [:])
                            throw NSError(domain:apiRequest.path, code:httpResponse.statusCode, userInfo:responseJSON as? [String : Any])
                        }
                    }
                } catch let error {
                    debugPrint(error)
                    single(.error(error))
                }
            }
            task.resume()
            
            return disposable
        }
    }
    
    func convertDictToJSON(dict: [String:Any]) -> NSString {
        let jsonbody = try! JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
        return NSString(data: jsonbody, encoding: String.Encoding.utf8.rawValue) ?? ""
    }
    
    fileprivate func debugPrintResponse<T: Decodable>(Type: T.Type, dict: [String:Any]) {
        debugPrint("Response of \(Type.self):", self.convertDictToJSON(dict: dict))
    }
    
    fileprivate func debugPrintRequest(apiRequest: RequestModel) {
        
        debugPrint("URL: ", apiRequest.url.description)
        
        debugPrint("Path: ", apiRequest.path)
        
        debugPrint("Method: ", apiRequest.method)
        
        if let header = apiRequest.header {
            debugPrint("Header: ",self.convertDictToJSON(dict: header))
        }
        
        if let body = apiRequest.bodyParameters {
            debugPrint("Post Body: ",self.convertDictToJSON(dict: body))
        }
        
        if let getBody = apiRequest.getRequestParameters {
            debugPrint("Get Body: ", self.convertDictToJSON(dict: getBody))
        }
    }
}

extension NetworkHandler: NetworkService {
    
    func serviceCall<T: Decodable>(apiRequest: RequestModel) -> Single<T> {
        return sender(apiRequest: apiRequest)
    }
}

public extension Error {
    public var code: Int { return (self as NSError).code }
    public var domain: String { return (self as NSError).domain }
    public var userInfo: [String : Any] { return (self as NSError).userInfo }
}

