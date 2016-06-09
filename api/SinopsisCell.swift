//
//  SinopsisCell.swift
//  api
//
//  Created by Alejandro Alvarado on 7/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//


class SinopsisCell: UITableViewCell {

    @IBOutlet weak var lblSinopsis: UILabel!
    
    override func layoutSubviews()
    {
        self.selectionStyle = .None
    }
}
