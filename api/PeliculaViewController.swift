//
//  FuncionesViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 3/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import UIKit

class PeliculaViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var segmentedCtl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var pelicula:[String:AnyObject?]!
    var header:HorarioPeliculaHeader!
    var cineID:String!
    let horariosDataSource = HorariosDataSource()
    let sinopsisDataSource = SinopsisDataSource()

    static let horarioCellID = "horario"
    static let sinopsisCellID = "sinopsis"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let horarioNib = UINib(nibName: "HorarioCell", bundle: nil)
        tableView.registerNib(horarioNib, forCellReuseIdentifier: PeliculaViewController.horarioCellID)
        tableView.estimatedRowHeight = 108
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        
        let sinopsisNib = UINib(nibName: "SinopsisCell", bundle: nil)
        tableView.registerNib(sinopsisNib, forCellReuseIdentifier: PeliculaViewController.sinopsisCellID)
        segmentedCtl.addTarget(self, action: #selector(PeliculaViewController.segmentIndexChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func segmentIndexChanged()
    {
        let showSinopsis = segmentedCtl.selectedSegmentIndex == 1
        tableView.dataSource = showSinopsis ? sinopsisDataSource : horariosDataSource
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        sinopsisDataSource.sinopsis = pelicula["Sinopsis"] as? String ?? ""
        let peliID = pelicula["ID"] as! String
        App.webapi.getJson("/peliculas/xhorario/"+cineID+"/"+peliID, done:
        {
            if let error = $0.error { self.handleError(error); return }
            if let horarios = $0.json as? [[String:AnyObject]]
            {
                self.horariosDataSource.data = horarios
                self.tableView.dataSource = self.horariosDataSource
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 0
        {
            return nil
        }
        
        if header == nil
        {
            let nib = UINib(nibName: "HorarioPeliculaHeader", bundle: nil)
            header = nib.instantiateWithOwner(nil, options: nil)[0] as? HorarioPeliculaHeader
            header?.lblTitulo.text = pelicula["Name"] as? String
            header.clipsToBounds = true
        }
        
        return header
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view =  UIView()
        view.frame = CGRectMake(0, 0, tableView.frame.width, 0.1)
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 150
    }
    
}

class HorariosDataSource : NSObject, UITableViewDataSource
{
    var data:[[String:AnyObject]]!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PeliculaViewController.horarioCellID, forIndexPath: indexPath) as! HorarioCell
        let funcion = data[indexPath.row]
        let dateString = funcion["fechahora"] as? String ?? ""
        
        if let date = dateFromString(dateString, format: ISO8601dateTimeFormat)
        {
            var dateString = stringFromDate(date, format: "EEEE")!.capitalizedString
            dateString += ", " + stringFromDate(date, format: "dd 'de' MMMM 'de' yyyy")!
            cell.lblFecha.text = dateString
            cell.lblHora.text = stringFromDate(date, format: "HH:mm")
        }
        
        var attrString = ""
        if let attribs = funcion["Attributes"] as? String
        {
            attrString = attribs.stringByReplacingOccurrencesOfString(";", withString: " | ")
        }
        cell.lblAttr.text = attrString
        cell.lblSala.text = (funcion["Sala"] as? String)?.capitalizedString
        
        return cell
    }
}

class SinopsisDataSource : NSObject, UITableViewDataSource
{
    var sinopsis = ""
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PeliculaViewController.sinopsisCellID, forIndexPath: indexPath) as! SinopsisCell
        cell.lblSinopsis.text = sinopsis
        return cell
    }
    
}