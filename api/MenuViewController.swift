//
//  MenuViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController, UITableViewDataSource
{
    @IBOutlet weak var tblMenu: UITableView!
    
    var contentViewController:ContainerNavigationController!
    {
        //Cuando inicia la app, mostrar el primer view controller del menú por default
        didSet
        {
            let firstNib = UINib(nibName: items[0].nibName, bundle: nil)
            let firstVc = firstNib.instantiateWithOwner(nil, options: nil)[0] as! UIViewController
            contentViewController.viewControllers = [firstVc]
        }
    }
    
    //Opciones que aparecen en el menú
    private let items =
    [
        MenuItem(nibName:"CinesViewController", iconName: "", name:"Cartelera"),
        MenuItem(nibName:"CinesViewController", iconName: "", name:"Bistro"),
        MenuItem(nibName:"CinesViewController", iconName: "", name:"Estreno"),
        MenuItem(nibName:"CinesViewController", iconName: "", name:"Promociones"),
        MenuItem(nibName:"CinesViewController", iconName: "", name:"Dulcería"),
        MenuItem(nibName:"UbicacionesViewController", iconName: "", name:"Ubicaciones"),
    ]
    
    //Reuse identifier para las celdas
    private let menuItemCellID = "menu"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Registrar celdas para la tabla
        let menuItemNib = UINib(nibName: "MenuItemCell", bundle: nil)
        tblMenu.registerNib(menuItemNib, forCellReuseIdentifier: menuItemCellID)
        tblMenu.dataSource = self
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuItemCellID, forIndexPath: indexPath) as! MenuItemCell
        let item = items[indexPath.row]
        
        cell.lblNombre.text = item.name
        cell.imgIcono.image = UIImage(named: item.iconName)
        
        return cell
    }
}

class MenuItem
{
    let nibName:String
    let iconName:String
    let name:String
    
    init(nibName:String, iconName:String, name:String)
    {
        self.nibName = nibName
        self.iconName = iconName
        self.name = name
    }
}