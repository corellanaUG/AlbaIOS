//
//  AppDelegate.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import UIKit

@UIApplicationMain
class App: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //Instancia global del cliente del api
    static let webapi = WebApi(baseUrl: NSURL(string: "http://cines.softwarecj.com")!)
    static var imagesUrl:NSURL!
    static var imagenes = [String:UIImage?]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        App.webapi.getJson("/urlimg")
        {
            if let urlText = $0.json as? String
            {
                App.imagesUrl = NSURL(string: urlText)
            }
        }
        
        let contenedor = ContainerNavigationController()
        let menuNib = UINib(nibName: "MenuViewController", bundle: nil)
        let menuVC = menuNib.instantiateWithOwner(nil, options: nil)[0] as! MenuViewController
        menuVC.contentViewController = contenedor
        
        let refrostedvc = REFrostedViewController(contentViewController: contenedor, menuViewController: menuVC)
        refrostedvc.direction = REFrostedViewControllerDirection.Left
        refrostedvc.menuViewSize = CGSizeMake(0.7 * window!.frame.width, window!.frame.height)
        refrostedvc.limitMenuViewSize = true
        
        contenedor.menuVC = refrostedvc
        
        window?.rootViewController = refrostedvc;
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

