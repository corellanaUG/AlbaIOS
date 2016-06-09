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
    var panGestureRecognizer:UIPanGestureRecognizer!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ContainerNavigationController.openMenu))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func openMenu()
    {
        if panGestureRecognizer.velocityInView(view).x >= 0
        {
            menuVC?.presentMenuViewController()
        }
        
    }
}