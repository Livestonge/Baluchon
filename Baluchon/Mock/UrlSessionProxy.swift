//
//  MockUrlSession.swift
//  BaluchonTests
//
//  Created by Awaleh Moussa Hassan on 28/05/2022.
//

import Foundation

// Create a subclass of UrlProtocol
// Instantiate a ephermale urlSessionConfiguration instance and assign newly created urlProtocol to his protocolClasses proprieties.
// Instantiate a urlsession instance with the newly created configuration
// Create an instance of an FixerServiceProviding object with the new urlSession instance.

class UrlSessionProxy: URLProtocol{
  static var error: Error?
  static var requestHandler: ((URLRequest) throws -> (Data, HTTPURLResponse))?
  
  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override class func canInit(with task: URLSessionTask) -> Bool {
    return true
  }
  
  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    print("canonical request with \(request.url)")
    return request
  }

  
  override func startLoading() {
    print("start loading")
    if let error = UrlSessionProxy.error{
      client?.urlProtocol(self, didFailWithError: error)
    }
    
    guard let handler = UrlSessionProxy.requestHandler else {
      assertionFailure("Did receive nil for the request handler")
      return
    }
    print("Handler do exist ")
    do{
      let (data, response) = try handler(request)
      client?.urlProtocol(self,
                          didReceive: response,
                          cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: data)
      client?.urlProtocolDidFinishLoading(self)
      print("client updated")
      
    } catch {
      client?.urlProtocol(self, didFailWithError: error)
    }
  }
  
  override func stopLoading() {
    client?.urlProtocolDidFinishLoading(self)
  }
  
  static func reset(){
    self.error = nil
    self.requestHandler = nil
    print("did reset")
  }
  
}
