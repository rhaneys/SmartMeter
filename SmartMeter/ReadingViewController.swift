//
//  ReadingViewController.swift
//  SmartMeter
//
//  Created by Richard Yip on 19/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import Foundation
import UIKit

class ReadingViewController: UIViewController {
    
    var viewModel:ReadingsModel?
    
    static func viewController(viewModel: ReadingsModel) -> ReadingViewController {
        let viewController = UIStoryboard(name: "Readings", bundle: nil).instantiateViewControllerWithIdentifier("ReadingViewController") as! ReadingViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

