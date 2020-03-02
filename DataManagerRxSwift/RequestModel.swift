//
//  verifyCustomerRequest.swift
//  Login MVVM Demo
//
//  Created by ttmac2 on 28/01/19.
//  Copyright © 2019 ttmac2. All rights reserved.
//

import Foundation

public class RequestModel: ServiceRequest {
    
    public var url: URL
    public var method: String
    public var path: String
    public var getRequestParameters: [String : String]?
    public var bodyParameters: [String : Any]?
    public var header: [String : Any]?
    
    public init(url: URL, path: String, method: String, header: [String:Any]?, bodyParameters: [String:Any]?, getRequestParameters: [String:String]?) {
        self.url = url
        self.bodyParameters = bodyParameters
        self.method = method
        self.path = path
        self.header = header
        self.getRequestParameters = getRequestParameters
    }
    
    deinit {
        print("RequestModel Deinit")
    }
}
