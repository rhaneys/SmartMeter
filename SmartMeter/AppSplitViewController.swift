//
//  AppSplitViewController.swift
//  SmartMeter
//
//  Created by Richard Yip on 22/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import UIKit

class AppSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .AllVisible
        self.delegate = self
        
    }
    
    /*
     http://stackoverflow.com/questions/26060915/having-a-uinavigationcontroller-in-the-master-view-of-a-uisplitviewcontroller-in
    */
}
