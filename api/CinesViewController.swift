//
//  CinesViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class CinesViewController: BaseMenuViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tblCines: UITableView!
    
    var cines = [[String:AnyObject]]()
    
    //Si no es null, es porque estamos escogiendo cine para un estreno
    var peliEstreno:[String:AnyObject]?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Cartelera"
    }
    
    override func viewWillAppear(animated: Bool)
    {
        if cines.count > 0 { llenarTabla(); return }
        
        var url = "/cines"
        
        if params?["bistro"] != nil { url = "/cines/bistro"}
        
        App.webapi.getJson(url, done:
        {
            if let error = $0.error { self.handleError(error); return }
            self.cines = $0.json as? [[String:AnyObject]] ?? []            
            self.llenarTabla()
        })
    }
    
    func llenarTabla()
    {
        tblCines.dataSource = self
        tblCines.delegate = self
        tblCines.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        let cine = cines[indexPath.row]
        cell.textLabel?.text = cine["Name"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cine = cines[indexPath.row]
        let next:UIViewController
        
        if let peliEstreno = peliEstreno
        {
            let nib = UINib(nibName: "PeliculaViewController", bundle: nil)
            let vc = nib.instantiateWithOwner(nil, options: nil)[0] as! PeliculaViewController
            
            vc.title = "Horarios"
            vc.pelicula = peliEstreno
            vc.cineID = cine["ID"] as? String
            //vc.fecha = self.fechas[fechaSeleccionada]            
            next = vc
        }
        else
        {
            let menuNib = UINib(nibName: "PeliculasCineViewController", bundle: nil)
            let vc = menuNib.instantiateWithOwner(nil, options: nil)[0] as! PeliculasCineViewController
            vc.cineID = cine["ID"] as? String
            vc.title = cine["Name"] as? String
            next = vc
        }
        
        
        navigationController?.pushViewController(next, animated: true)
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Seleccione una ubicación"
    }
}

class CinesEstrenosViewController : CinesViewController
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = super.view
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}