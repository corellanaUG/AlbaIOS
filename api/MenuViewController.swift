//
//  MenuViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tblMenu: UITableView!
    
    var contentViewController:ContainerNavigationController!
    {
        //Cuando inicia la app, mostrar el primer view controller del menú por default
        didSet {  selectItem(0)  }
    }
    
    //Opciones que aparecen en el menú
    private let items =
    [
        MenuItem(nibName:"CinesViewController", iconName: "ticket", name:"Cartelera"),
        MenuItem(nibName:"GalleryViewController", iconName: "bistro", name:"Bistro"),
        MenuItem(nibName:"EstrenosViewController", iconName: "estrenos", name:"Estreno"),
        MenuItem(nibName:"CinesViewController", iconName: "promo", name:"Promociones"),
        MenuItem(nibName:"GalleryViewController", iconName: "dulceria", name:"Dulcería"),
        MenuItem(nibName:"UbicacionesViewController", iconName: "location", name:"Ubicaciones"),
    ]
    
    //Reuse identifier para las celdas
    private let menuItemCellID = "menu"
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Registrar celdas para la tabla
        let menuItemNib = UINib(nibName: "MenuItemCell", bundle: nil)
        tblMenu.registerNib(menuItemNib, forCellReuseIdentifier: menuItemCellID)
        
        //Settear delegate y datasource
        tblMenu.dataSource = self
        tblMenu.delegate = self
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectItem(indexPath.row)
    }
    
    func selectItem(position:Int)
    {
        let nib = UINib(nibName: items[position].nibName, bundle: nil)
        let vc = nib.instantiateWithOwner(nil, options: nil)[0] as! UIViewController
        contentViewController.viewControllers = [vc]
        contentViewController.menuVC?.hideMenuViewController()
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view =  UIView()
        view.frame = CGRectMake(0, 0, tableView.frame.width, 0.1)
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
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