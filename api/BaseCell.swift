//
//  BaseCell.swift
//  api
//
//  Created by Alejandro Alvarado on 7/06/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import Foundation

class BaseCell: UITableViewCell
{
    private let blurViewTag = 420
    override func layoutSubviews()
    {
        self.selectionStyle = .None
        /*
        
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = UIEdgeInsetsZero
        
        if viewWithTag(blurViewTag) == nil
        {
            let effect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            let effectView = UIVisualEffectView(effect: effect)
            effectView.tag = blurViewTag
            effectView.frame = self.bounds
            self.insertSubview(effectView, atIndex: 0)
            effectView.autoresizingMask = UIViewAutoresizing([.FlexibleWidth, .FlexibleHeight])
        }
        */
    }
    
    
}