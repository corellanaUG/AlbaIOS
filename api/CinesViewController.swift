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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Cines"
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
        let vc = UIViewController()
        vc.title = cine["Name"] as? String
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
}