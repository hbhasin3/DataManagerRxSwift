import Foundation
import UIKit

public protocol ServiceRequest {
    var url: URL { get }
    var method: String { get }
    var path: String { get }
    var getRequestParameters: [String : String]? { get }
    var bodyParameters: [String : Any]? { get }
    var header: [String : Any]? { get }
}

extension ServiceRequest {
    func request() -> URLRequest {
        guard var components = URLComponents(url: url.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        if let queryItems = getRequestParameters {
            components.queryItems = queryItems.map {
                URLQueryItem(name: String($0), value: String($1))
            }
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if request.httpMethod == "POST" {
            do {
                if let body = bodyParameters {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: []) // pass dictionary to nsdata object and set it as request body
                }
                
            } catch let error {
                //SwiftLog(message:"ERROR = \(error.localizedDescription)")
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if request.httpMethod == "PUT" {
            do {
                if let body = bodyParameters {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: []) // pass dictionary to nsdata object and set it as request body
                }
                
            } catch let error {
                //SwiftLog(message:"ERROR = \(error.localizedDescription)")
            }
        }
        
        if let header = header {
            for (key,value) in header {
                request.addValue(value as! String,forHTTPHeaderField:key)
            }
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
