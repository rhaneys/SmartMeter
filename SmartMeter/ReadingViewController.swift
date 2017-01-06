//
//  ReadingViewController.swift
//  SmartMeter
//
//  Created by Richard Yip on 19/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import Foundation
import UIKit

class ReadingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController.init()
    var viewModel:ReadingsModel?
    @IBOutlet weak var readingImageView: UIImageView!

    
    static func viewController(viewModel: ReadingsModel) -> ReadingViewController {
        let viewController = UIStoryboard(name: "Readings", bundle: nil).instantiateViewControllerWithIdentifier("ReadingViewController") as! ReadingViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.delegate = self
        self.picker.allowsEditing = false
        self.setupUI()
    }
    
    func setupUI() {
        
        let alertController:UIAlertController = UIAlertController.init(title: "Meter Image", message: nil, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
        { (action) in
            // ...
        }
        
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .Default)
        { (action) in
            // ...
            self.picker.sourceType = .PhotoLibrary

            self.presentViewController(self.picker, animated: true, completion: nil)
            
        }
        
        alertController.addAction(okAction)
        
        let tableViewController = UITableViewController.init(style: .Grouped)
        tableViewController.preferredContentSize = CGSize(width: 272, height: 270) // 4 default cell heights.
        
        tableViewController.tableView.registerClass(MeterListCell.self, forCellReuseIdentifier: "MeterListCell")
        tableViewController.tableView.registerClass(ImageListCell.self, forCellReuseIdentifier: "ImageListCell")
        
        tableViewController.tableView.scrollEnabled = false;
        
        // Mark: UITableview delegates
        tableViewController.tableView.delegate = self
        tableViewController.tableView.dataSource = self
        
        //  bind the model
        viewModel?.selectedMeterType.signal.observeNext { (selectedMeterType) in
            tableViewController.tableView.reloadData()
        }
        
        viewModel?.selectedImageSource.signal.observeNext { (selectedImageSource) in
            tableViewController.tableView.reloadData()
        }
        
        alertController.setValue(tableViewController, forKey: "contentViewController")
        
        //...
        var rootViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // Mark TableView delegates
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.min
        }
        return 25
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 1 {
            return CGFloat.min
        }
        return 25
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (viewModel?.meterListType.value.count)!
        }
        if section == 1 {
            return (viewModel?.imageListSource.value.count)!
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell()
        cell.selectionStyle = .None
        var meterType:String
        var imageSource:String
        
        let shortPath = (indexPath.section, indexPath.row)
        switch shortPath {
        case(0, 0...((viewModel?.meterListType.value.count)! - 1)):
            cell = tableView.dequeueReusableCellWithIdentifier("MeterListCell")!
            meterType = (viewModel?.meterListType.value[shortPath.1])!
            cell.textLabel?.text = meterType
            cell.accessoryType = viewModel?.selectedMeterType.value == meterType ? .Checkmark : .None
            cell.textLabel?.font = UIFont .preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell.selectionStyle = .None
            break
        case(1, 0...(viewModel?.imageListSource.value.count)! - 1):
            cell = tableView.dequeueReusableCellWithIdentifier("ImageListCell")!
            imageSource = (viewModel?.imageListSource.value[shortPath.1])!
            cell.textLabel?.text = imageSource
            cell.accessoryType = viewModel?.selectedImageSource.value == imageSource ? .Checkmark : .None
            cell.textLabel?.font = UIFont .preferredFontForTextStyle(UIFontTextStyleSubheadline)
            cell.selectionStyle = .None
            break
        default:break
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        var meterType:String
        var imageSource:String
        
        let shortPath = (indexPath.section, indexPath.row)
        
        switch shortPath {
        case(0, 0...((viewModel?.meterListType.value.count)! - 1)):
            meterType = (viewModel?.meterListType.value[shortPath.1])!
            viewModel?.selectMeterType(meterType)
            break
        case(1, 0...(viewModel?.imageListSource.value.count)! - 1):
            imageSource = (viewModel?.imageListSource.value[shortPath.1])!
            viewModel?.selectImageSource(imageSource)
            break
        default: break

        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            readingImageView.image = image
        }
        else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let orientedImage = image.fixedOrientation()
            readingImageView.image = SmartMeterOpenCV.init().grayImage(orientedImage)
        } else{
            print("Something went wrong")
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    

}

