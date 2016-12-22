//
//  ReadingsViewController.swift
//  SmartMeter
//
//  Created by Richard Yip on 19/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import UIKit

class ReadingsViewController: UITableViewController {
    
    var viewModel:ReadingsModel?
    
    static func viewController(viewModel: ReadingsModel) -> ReadingsViewController {
        let viewController = UIStoryboard(name: "Readings", bundle: nil).instantiateViewControllerWithIdentifier("ReadingsViewController") as! ReadingsViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindViewModel()
        
    }
    
    func setupUI(){
        self.title = NSLocalizedString("Readings", comment: "Readings.Title")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: nil, action: nil)
    }
    
    func bindViewModel() {

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Mark: UITableview delegates
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel?.readings.value.count)!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ReadingsCell")
        return cell!
    }
    
}
