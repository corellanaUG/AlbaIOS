//
//  PeliculaCellTableViewCell.swift
//  api
//
//  Created by Alejandro Alvarado on 2/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import UIKit

class PeliculaCell: UITableViewCell {

    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var imgPelicula: UIImageView!
    @IBOutlet weak var lblClasificacion: UILabel!
    @IBOutlet weak var lblGenero: UILabel!
    @IBOutlet weak var lblSinopsis: UILabel!
    @IBOutlet weak var lblDuracion: UILabel!
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        lblClasificacion.layer.cornerRadius = 4
        lblClasificacion.layer.borderWidth = 1
        lblClasificacion.layer.borderColor = UIColor.lightGrayColor().CGColor
        lblClasificacion.layer.masksToBounds = true
    }
}
