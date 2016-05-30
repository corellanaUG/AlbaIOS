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
    
    func getJson(path:String, urlparams:[NSURLQueryItem]? = nil, bodyParams:[String:AnyObject]? = nil,method:String = "GET", done: (JsonResult) -> () )
    {
        let components = NSURLComponents(URL: baseUrl, resolvingAgainstBaseURL: false)!
        components.path = path
        components.queryItems = urlparams
        
        let url = components.URL!
        let request = NSMutableURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        if let bodyParams = bodyParams
        {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(bodyParams, options: [])
        }
        
        print(url)
        
        session.dataTaskWithRequest(request) { (data, response, error) in
            dispatch_async(dispatch_get_main_queue(), {done(JsonResult(data: data, response: response, error: error))})
        }.resume()
    }        
}

class JsonResult
{
    var json:AnyObject?
    var error:NSError?
    var response:NSHTTPURLResponse?
    var data:NSData?
    
    init(data:NSData?, response:NSURLResponse?, error:NSError?)
    {
        self.error = error
        self.response = response as? NSHTTPURLResponse
        self.data = data
        
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