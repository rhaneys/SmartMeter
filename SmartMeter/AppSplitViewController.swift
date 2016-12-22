//
//  AppSplitViewController.swift
//  SmartMeter
//
//  Created by Richard Yip on 22/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import UIKit

class AppSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .AllVisible
        
    }
    
    override func showDetailViewController(vc: UIViewController, sender: AnyObject?) {
        
        
    }
    
    func primaryViewControllerForCollapsingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
        return self.viewControllers.first
    }
    

    func primaryViewControllerForExpandingSplitViewController(splitViewController: UISplitViewController) -> UIViewController? {
        return self.viewControllers.first
    }
}
