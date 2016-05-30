//
//  BaseMenuViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

//Todos los viewcontrollers que quieran tener el botón de hamburguesa para abrir el menú
//Deben de heredar de este viewcontroller
class BaseMenuViewController: BaseViewController
{
    var menu: REFrostedViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let hamburger = UIImage(named: "hamburger")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: hamburger, style: .Plain, target: self.navigationController, action: #selector(ContainerNavigationController.openMenu))
    }
    
}