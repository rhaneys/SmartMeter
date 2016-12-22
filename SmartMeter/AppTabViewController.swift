//
//  AppTabViewController.swift
//  SmartMeter
//
//  Created by Richard Yip on 13/12/15.
//  Copyright © 2015 Richard Yip. All rights reserved.
//

import UIKit
import XCGLogger

class AppTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let viewControllerArray = self.loadTabs()
        self.setViewControllers(viewControllerArray as? [UIViewController], animated: true)
    }
    
    func loadTabs() -> NSArray {
        
        let readingsModel:ReadingsModel = ReadingsModel()
        let readingsViewController:ReadingsViewController = ReadingsViewController.viewController(readingsModel)

        let nav:UINavigationController = self.loadTabWithTitle("Readings", viewController: readingsViewController, image: "", selectedImage: "")
        let array:Array = Array.init(arrayLiteral: nav)
        return array
        
    }
    
    func loadTabWithTitle(title:String, viewController:UIViewController, image:String, selectedImage:String) -> UINavigationController {
        
        let tbi:UITabBarItem = UITabBarItem.init(tabBarSystemItem: .Favorites, tag: 0)
        
        viewController.tabBarItem = tbi
        viewController.title = title
        
        let nav:UINavigationController = UINavigationController.init(rootViewController: viewController)
        return nav
    }
    
}
