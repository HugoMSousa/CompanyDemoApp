//
//  Endpoints.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 11/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Alamofire

// http://jsonplaceholder.typicode.com/users
// http://jsonplaceholder.typicode.com/albums
// http://jsonplaceholder.typicode.com/photos

public enum APIEndpoints {
  case Users
  case Albums
  case Photos
  
  public var method: Alamofire.Method {
    switch self {
    case .Users,
    .Albums,
    .Photos:
      return Alamofire.Method.GET
    }
  }
  
  public var baseURL: String {
    return "http://jsonplaceholder.typicode.com"
  }
  
  public var path: String {
    switch self {
    case .Users:  return baseURL+"/users"
    case .Albums: return baseURL+"/albums"
    case .Photos: return baseURL+"/photos"
    }
  }
  
  public var parameters: [String: AnyObject] {
    var parameters = [String: AnyObject]()
    switch self {
    case .Users:
      break
    case .Albums:
      break
    case .Photos:
      break
    }
    return parameters
  }
}

protocol CompanyAPI {
  static func request(endpoint: APIEndpoints, completion: Response<AnyObject, NSError> -> Void) -> Request
}

