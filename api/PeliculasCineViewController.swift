//
//  PeliculasCineViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 1/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation
import BTNavigationDropdownMenu

class PeliculasCineViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet weak var tblPeliculas: UITableView!
    
    var peliculas = [[String:AnyObject]]()
    var cineID:String!
    var imagenesApi:WebApi?
    var fechas = [String]()
    var fechaSeleccionada = 0
    var menuFechas:BTNavigationDropdownMenu!
    var bistro = false
    
    let peliculasCellID = "peliculas"
    
    override func viewDidLoad() {
        if let url = App.imagesUrl {
            imagenesApi = WebApi(baseUrl: url)
        }
        
        let peliculasNib = UINib(nibName: "PeliculaCell", bundle: nil)
        tblPeliculas.registerNib(peliculasNib, forCellReuseIdentifier: peliculasCellID)
        tblPeliculas.estimatedRowHeight = 166
        tblPeliculas.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        getFechas()
    }
    
    func getFechas()
    {
        let params = [NSURLQueryItem(name: "idcine", value: cineID)]
        App.webapi.getJson("/peliculas/filtrarFechas", urlparams: params, done:
        {
            if let error = $0.error { self.handleError(error); return }
            let fechasJson = $0.json as? [[String:AnyObject]] ?? []
            self.fechas = fechasJson.map( { $0["fecha"] as? String ?? ""})
            self.llenarFechas()
            self.getPeliculas()
        })
    }

    func getPeliculas()
    {
        var params = [NSURLQueryItem(name: "fecha", value: fechas[fechaSeleccionada])]
        
        if bistro
        {
            params.append(NSURLQueryItem(name: "bistro", value: "1"))
        }
        
        App.webapi.getJson("/peliculas/xcine2/"+cineID, urlparams: params, done:
        {
            if let error = $0.error { self.handleError(error); return }
            self.peliculas = $0.json as? [[String:AnyObject]] ?? []
            self.llenarTabla()
        })
    }
    
    func llenarTabla()
    {
        tblPeliculas.dataSource = self
        tblPeliculas.delegate = self
        tblPeliculas.reloadData()
    }
    
    func llenarFechas()
    {
        if self.navigationController == nil
        {
            print("mew")
            return
        }
        
        
        
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
            self.fechaSeleccionada = $0
            self.getPeliculas()
        };
        
        self.navigationItem.titleView =  menuFechas
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        if let menuFechas = menuFechas
        {
            menuFechas.hide()
        }
        self.navigationItem.titleView = nil
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier(peliculasCellID, forIndexPath: indexPath) as! PeliculaCell
        let pelicula = peliculas[indexPath.row]
        
        cell.lblTitulo.text = pelicula["Name"] as? String
        cell.lblGenero.text = (pelicula["Genero"] as? String)?.capitalizedString
        cell.lblClasificacion.text = pelicula["Rating"] as? String
        cell.lblDuracion.text = (pelicula["Duracion"] as? String ?? "") + " min."
        
        var sinopsis = pelicula["Sinopsis"] as? String ?? ""
        let length = 100
        if (sinopsis.characters.count > length)
        {
            sinopsis = String(sinopsis.characters.dropLast(sinopsis.characters.count - length))
            
            if let lastSpace = sinopsis.lastIndexOf(" ")
            {
                sinopsis = String(sinopsis.characters.dropLast(length - lastSpace))
            }
            
            sinopsis += "..."
        }
        
        cell.lblSinopsis.text = sinopsis
        
        
        let imgPath = (pelicula["Url"] as? String ?? "")
        
        if let img = App.imagenes[imgPath]
        {
            cell.imgPelicula.image = img
        }
        else if imgPath != ""
        {
            imagenesApi?.getImage(imgPath, done:
            {
                let imgOrDefault = $0.image ?? UIImage(named: "no-image")
                cell.imgPelicula.image = imgOrDefault
                App.imagenes[imgPath] = imgOrDefault
            })
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? PeliculaCell
        {
            cell.imgPelicula.image = UIImage(named: "no-image")
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let pelicula = peliculas[indexPath.row]
        let menuNib = UINib(nibName: "PeliculaViewController", bundle: nil)
        let vc = menuNib.instantiateWithOwner(nil, options: nil)[0] as! PeliculaViewController
        
        vc.title = "Horarios"
        vc.pelicula = pelicula
        vc.cineID = cineID
        vc.fecha = self.fechas[fechaSeleccionada]
        vc.bistro = self.bistro
        navigationController?.pushViewController(vc, animated: true)
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
        return self.title
    }
    
}

extension String
{
    func lastIndexOf(target: String) -> Int? {
        if let range = self.rangeOfString(target, options: .BackwardsSearch) {
            return startIndex.distanceTo(range.startIndex)
        } else {
            return nil
        }
    }
}
