//
//  BaseViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class BaseViewController : UIViewController
{
    var params: [String:AnyObject]?
    private var listeningToRotation = false
    
    override func viewDidLoad()
    {
        self.view.clipsToBounds = true
    }
    
    func handleError(error:NSError)
    {
        print(error)
        //Error de red
        if error.domain == NSURLErrorDomain
        {
            handleConnectionError(error)
        }
        else
        {
            let message = error.domain == "Estudiantes" ? error.localizedDescription : "Ha ocurrido un error."
            showAlert("Lo sentimos", message: message)
        }
    }
    
    func showAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleConnectionError(error:NSError)
    {
        showAlert("Lo sentimos", message: "Ha ocurrido un error de conexión.")
    }
    
    
    func startListeningToRotation()
    {
        if !listeningToRotation
        {
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BaseViewController.rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
        }
    }
    
    func stopListeningToRotation()
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    deinit
    {
        stopListeningToRotation()
    }
    
    func rotated()
    {
        
    }
    
    
}