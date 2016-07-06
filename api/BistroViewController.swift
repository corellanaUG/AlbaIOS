//
//  BistroViewController.swift
//  api
//
//  Created by Alejandro Alvarado on 6/07/16.
//  Copyright © 2016 Universidad Galileo. All rights reserved.
//

import UIKit

class BistroViewController: BaseMenuViewController {

    @IBOutlet weak var ctlSegments: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    var vcCines:CinesViewController!
    var vcGaleria:GalleryViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Bistro"
        createCines()
        createGallery()
        showVC(vcCines)
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl)
    {
        showVC(sender.selectedSegmentIndex == 0 ? vcCines : vcGaleria)
    }

    func createCines()
    {
        let nib = UINib(nibName: "CinesViewController", bundle: nil)
        vcCines = nib.instantiateWithOwner(nil, options: nil)[0] as! CinesViewController
        vcCines.params = ["bistro":true]
        vcCines.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func createGallery()
    {
        let nib = UINib(nibName: "GalleryViewController", bundle: nil)
        vcGaleria = nib.instantiateWithOwner(nil, options: nil)[0] as! GalleryViewController
        vcGaleria.params = ["path":"/Bistro", "title":"Bistro"]
        vcGaleria.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func showVC(viewController:UIViewController)
    {
        self.containerView.subviews.forEach({$0.removeFromSuperview()})
        self.addChildViewController(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        let h = NSLayoutConstraint.constraintsWithVisualFormat("H:|[childView]|", options: [], metrics: nil, views: ["childView" : viewController.view])
        let v = NSLayoutConstraint.constraintsWithVisualFormat("V:|[childView]|", options: [], metrics: nil, views: ["childView" : viewController.view])
        self.view.addConstraints(h);
        self.view.addConstraints(v);
    }
}
