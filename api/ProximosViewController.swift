//
//  ProximosViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 29/08/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class ProximosViewController: BaseMenuViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tblPeliculas: UITableView!
    var peliculas = [[String:AnyObject]]()
    var imagenesApi:WebApi?
    let peliculasCellID = "peliculas"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Próximos Estrenos"
        
        
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
        App.webapi.getJson("/Proximos/", done:
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
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view =  UIView()
        view.frame = CGRectMake(0, 0, tableView.frame.width, 0.1)
        view.backgroundColor = UIColor.lightGrayColor()
        return view
    }
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? PeliculaCell
        {
            cell.imgPelicula.image = UIImage(named: "no-image")
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.5
    }
}