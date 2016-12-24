//
//  ReadingsModel.swift
//  SmartMeter
//
//  Created by Richard Yip on 19/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import UIKit
import ReactiveCocoa
import RealmSwift


class ReadingsModel: NSObject {
    
    var notificationToken: NotificationToken? = nil
    let selectedReading = MutableProperty("")
    let readings = MutableProperty([MeterReading]())
    
    override init() {
        super.init()
        let realm = try! Realm()
        let results = realm.objects(MeterReading.self)
        
        notificationToken = results.addNotificationBlock{ [weak self] (changes: RealmCollectionChange) in
           guard (self?.readings) != nil else { return }
            
            self!.readings.value = results.map { $0 }
            print("readings ", self!.readings)
        }
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    func fetchReadings() {
        
    }
    
}
