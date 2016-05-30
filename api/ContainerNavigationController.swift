//
//  ContainerNavigationController.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class ContainerNavigationController: UINavigationController
{
    var menuVC: REFrostedViewController?
    
    func openMenu()
    {        
        menuVC?.presentMenuViewController()
    }
}