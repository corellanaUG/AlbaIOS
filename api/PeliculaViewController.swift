//
//  FuncionesViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 3/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import UIKit
import BTNavigationDropdownMenu

class PeliculaViewController: BaseViewController, UITableViewDelegate {

    @IBOutlet weak var segmentedCtl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgPelicula: UIImageView!
    @IBOutlet weak var lblClasificacion: UILabel!
    @IBOutlet weak var lblGenero: UILabel!
    @IBOutlet weak var lblDuracion: UILabel!
    @IBOutlet weak var lblTitulo: UILabel!
    
    var pelicula:[String:AnyObject?]!
    var header:HorarioPeliculaHeader!
    var cineID:String!
    var fecha:String!
    let horariosDataSource = HorariosDataSource()
    let sinopsisDataSource = SinopsisDataSource()
    var fechas = [String]()
    var menuFechas:BTNavigationDropdownMenu!
    private var estreno = false

    static let horarioCellID = "horario"
    static let sinopsisCellID = "sinopsis"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let horarioNib = UINib(nibName: "HorarioNewCell", bundle: nil)
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
        
        scrollToFirstRow()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        llenarHeader()
        
        if fecha != nil
        {
            getHorarios()
        }
        else
        {
            estreno = true
            getFechas()
        }
    }
    
    func getHorarios()
    {
        let peliID = pelicula["Name"] as! String
        let fecha = [NSURLQueryItem(name: "fecha", value: self.fecha)]
        
        App.webapi.getJson("/peliculas/xhorario2/"+cineID+"/"+peliID, urlparams: fecha, done:
        {
            if let error = $0.error { self.handleError(error); return }
            if let horarios = $0.json as? [[String:AnyObject]]
            {
                self.horariosDataSource.data = horarios
                self.horariosDataSource.fecha = self.estreno ? (" - " + self.fecha) : ""
                self.tableView.dataSource = self.horariosDataSource
                self.tableView.reloadData()
            }
        })
    }
    
    func llenarHeader()
    {
        sinopsisDataSource.sinopsis = pelicula["Sinopsis"] as? String ?? ""
        lblGenero.text = (pelicula["Genero"] as? String)?.capitalizedString
        lblTitulo.text = pelicula["Name"] as? String
        lblDuracion.text = (pelicula["Duracion"] as? String ?? " ") + " minutos"
        lblClasificacion.text = pelicula["Rating"] as? String
        
        if let imgUrl = pelicula["Url"] as? String
        {
            if let img = App.imagenes[imgUrl]
            {
                imgPelicula.image = img
            }
        }
    }

    func getFechas()
    {
        let nombre = pelicula["Name"] as? String
        let params = [NSURLQueryItem(name: "idcine", value: cineID),
                      NSURLQueryItem(name:"pelicula", value: nombre)]
        App.webapi.getJson("/peliculas/filtrarFechas", urlparams: params, done:
        {
            if let error = $0.error { self.handleError(error); return }
            let fechasJson = $0.json as? [[String:AnyObject]] ?? []
            self.fechas = fechasJson.map( { $0["fecha"] as? String ?? ""})
            self.fecha = self.fechas[0]
            self.llenarFechas()
            self.getHorarios()
        })
    }

    func llenarFechas()
    {
        menuFechas = BTNavigationDropdownMenu(navigationController: self.navigationController, title: fechas.first!, items: fechas)
        menuFechas.cellHeight = 30
        menuFechas.cellTextLabelFont = UIFont.systemFontOfSize(14, weight: 0.1)
        menuFechas.cellTextLabelAlignment = .Center
        menuFechas.arrowImage = UIImage(named: "arrow")
        menuFechas.cellSeparatorColor = UIColor.clearColor()
        menuFechas.cellBackgroundColor = UIColor(colorLiteralRed: 0.95, green: 0.95, blue: 0.95, alpha: 0.95)
        menuFechas.keepSelectedCellColor = true
        menuFechas.checkMarkImage = nil
        menuFechas.didSelectItemAtIndexHandler =
        {
            self.fecha = self.fechas[$0]
            self.getHorarios()
        };
        self.navigationItem.titleView = menuFechas
    }

    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    
    func scrollToFirstRow() {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }
    
}

class HorariosDataSource : NSObject, UITableViewDataSource
{
    var data:[[String:AnyObject]]!
    var fecha = ""
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(PeliculaViewController.horarioCellID, forIndexPath: indexPath) as! HorarioNewCell
        let funcion = data[indexPath.row]
        
        cell.sgmHorario.removeAllSegments()
        if let horas = funcion["Horas"] as? [[String:AnyObject]]
        {
            var i = 0
            for hora in horas
            {
                var text = hora["hora"] as? String ?? "00:00:00"
                text = text.substringToIndex(text.endIndex.advancedBy(-3))
                
                cell.sgmHorario.insertSegmentWithTitle( text , atIndex: i, animated: false)
                i += 1
            }
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Horarios " + fecha
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
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Sinopsis"
    }
}