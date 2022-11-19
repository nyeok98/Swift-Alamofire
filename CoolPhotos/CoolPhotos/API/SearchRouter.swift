//
//  SearchRouter.swift
//  CoolPhotos
//
//  Created by NYEOK on 2022/11/19.
//

import Alamofire
import Foundation

enum SearchRouter: URLRequestConvertible {
    case searchPhotos(term: String)
    case searchUsers(term: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL + "/search")!
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .searchPhotos: return "/photos"
        case .searchUsers: return "/users"
        }
    }
    
    var params: [String: String] {
        switch self {
        case let .searchPhotos(term), let .searchUsers(term):
            return ["query": term]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method
        request = try URLEncodedFormParameterEncoder().encode(params, into: request)
        
        return request
    }
}
