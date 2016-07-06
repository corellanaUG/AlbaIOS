//
//  WebApi.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class WebApi
{
    var baseUrl:NSURL
    
    init(baseUrl:NSURL)
    {
        self.baseUrl = baseUrl
    }
    
    func getJson(path:String, urlparams:[NSURLQueryItem]? = nil, bodyParams:[String:AnyObject]? = nil,
                 method:String = "GET", useBaseUrl:Bool = true, done: (JsonResult) -> () )
    {
        let request = createRequest(path, urlparams: urlparams, bodyParams: bodyParams, method: method, useBaseUrl: useBaseUrl)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        sendRequest(request, done: {done(JsonResult(data: $0, response: $1, error: $2))})
    }
    
    func getImage(path:String, urlparams:[NSURLQueryItem]? = nil, bodyParams:[String:AnyObject]? = nil,
                  method:String = "GET", useBaseUrl:Bool = true, done: (ImageRsult) -> () )
    {
        let request = createRequest(path, urlparams: urlparams, bodyParams: bodyParams, method: method, useBaseUrl: useBaseUrl)
        sendRequest(request, done: {done(ImageRsult(data: $0, response: $1, error: $2))})
    }
    
    func createRequest(path:String, urlparams:[NSURLQueryItem]? = nil, bodyParams:[String:AnyObject]? = nil,
                       method:String = "GET", useBaseUrl:Bool = true) -> NSMutableURLRequest
    {
        let url:NSURL
        if useBaseUrl
        {
            let components = NSURLComponents(URL: baseUrl, resolvingAgainstBaseURL: false)!
            components.path = (components.path ?? "") + path
            components.queryItems = urlparams
            url = components.URL!
        }
        else
        {
            url = NSURL(string: path)!
        }
        
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        
        if let bodyParams = bodyParams
        {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyParams, options: [])
        }
        
        print(url)
        
        return request
    }
    
    func sendRequest(request: NSMutableURLRequest, done: (NSData?, NSURLResponse?, NSError?) -> ())
    {
        let session = NSURLSession.sharedSession()
        session.dataTaskWithRequest(request) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), { done(data, response, error) })
        }.resume()
    }
}

class ApiResult
{
    var error:NSError?
    var response:NSHTTPURLResponse?
    var data:NSData?
    
    init(data:NSData?, response:NSURLResponse?, error:NSError?)
    {
        self.error = error
        self.response = response as? NSHTTPURLResponse
        self.data = data
    }
}

class JsonResult : ApiResult
{
    var json:AnyObject?
    
    override init(data:NSData?, response:NSURLResponse?, error:NSError?)
    {
        super.init(data: data, response: response, error: error)
        
        if let data = data
        {
            do
            {
                json = try NSJSONSerialization.JSONObjectWithData(data, options: [.MutableContainers, .AllowFragments, .MutableLeaves])
            } catch let error as NSError
            {
                NSLog("Error al deserializar json: %s ", error.localizedDescription)
            }
        }
    }
}

class ImageRsult: ApiResult
{
    var image:UIImage?
    
    override init(data:NSData?, response:NSURLResponse?, error:NSError?)
    {
        super.init(data: data, response: response, error: error)
        
        if let data = data
        {
            image = UIImage(data: data)
        }
    }
}