//
//  CompanyAPI.swift
//  CompanyPhotos
//
//  Created by Hugo Sousa on 12/01/16.
//  Copyright © 2016 OpenSource. All rights reserved.
//

import Foundation
import Alamofire

class CompanyWebService: CompanyAPI {
  
  class func request(endpoint: APIEndpoints, completion: Response<AnyObject, NSError> -> Void) -> Request {
    return Alamofire.request(
      endpoint.method,
      endpoint.path,
      parameters: endpoint.parameters,
      encoding: .URL,
      headers: nil).validate().responseJSON(completionHandler: { response in
        completion(response)
      })
  }
}