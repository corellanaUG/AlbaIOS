//
//  UbicacionesViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 30/05/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class UbicacionesViewController: BaseMenuViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblUbicaciones: UITableView!
    
    var cines = [[String:AnyObject]]()
    private let ubicacionCellId = "ubicacion"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Ubicaciones"
        
        //Registrar celdas para la tabla
        let ubicacionCellNib = UINib(nibName: "UbicacionCell", bundle: nil)
        tblUbicaciones.registerNib(ubicacionCellNib, forCellReuseIdentifier: ubicacionCellId)
        tblUbicaciones.estimatedRowHeight = 136
        tblUbicaciones.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool)
    {
        App.webapi.getJson("/cines", done:
        {
            if let error = $0.error { self.handleError(error); return }
            self.cines = $0.json as? [[String:AnyObject]] ?? []
            self.llenarTabla()
        })
    }
    
    func llenarTabla()
    {
        tblUbicaciones.dataSource = self
        tblUbicaciones.delegate = self
        tblUbicaciones.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cines.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(ubicacionCellId, forIndexPath: indexPath) as! UbicacionCell
        let cine = cines[indexPath.row]
        
        cell.lblUbicacion.text = cine["Name"] as? String
        cell.lblAddress1.text = cine["Address1"] as? String
        cell.lblAddress2.text = cine["Address2"] as? String
        cell.lblParkingInfo.text = cine["ParkingInfo"] as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let cine = cines[indexPath.row]
        let lat = cine["Latitude"] as? String
        let lng = cine["Longitude"] as? String
        
        if let lat = lat, lng = lng
        {
            let query = "?ll=" + lat + "," + lng
            let wazeUrl = "waze://" + query
            let mapsUrl = "http://maps.apple.com/" + query
            let canOpenWaze = UIApplication.sharedApplication().canOpenURL(NSURL(string: wazeUrl)!)
            
            UIApplication.sharedApplication().openURL(NSURL(string: canOpenWaze ? wazeUrl : mapsUrl )!)
        }
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