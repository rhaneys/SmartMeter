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
    
}
