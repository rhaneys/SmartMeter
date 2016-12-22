//
//  MeterReadingRealm.swift
//  SmartMeter
//
//  Created by Richard Yip on 16/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import RealmSwift

enum MeterType:Int {
    case electricty = 0
    case gas = 1
    case water = 2
    case all = 99
}

enum MeterUnit:Int {
    case kWh = 0
    case CuM = 1
}

enum MeterProvider:Int {
    case SPServices = 0
    case CityGas = 1
    case Veolia = 2
}


class Meter: Object {
    dynamic var objectID = ""
    dynamic var type:Int = 0
    let readings = List<MeterReading>()
    let rates = List<Rate>()
    
    convenience init(reading:MeterReading, rate:Rate, type:Int) {
        self.init()
        readings.append(reading)
        rates.append(rate)
        objectID = NSUUID().UUIDString.lowercaseString
        self.type = type
    }
    
    override static func primaryKey() -> String? {
        return "objectID"
    }
    
    func addReading(reading:MeterReading) {
        try! realm!.write {
            readings.append(reading)
        }
    }
    
    func addRate(rate:Rate) {
        try! realm!.write {
            rates.append(rate)
        }
    }
}


class MeterReading: Object {
    dynamic var objectID = ""
    dynamic var reading:Int = 0
    dynamic var type:Int = 0
    dynamic var unit:Int = 0
    dynamic var timestamp:NSDate = NSDate.distantFuture()
    dynamic var estimated:Bool = false
    
    convenience init(reading:Int, type:Int,  unit:Int, timestamp:NSDate) {
        self.init()
        objectID = NSUUID().UUIDString.lowercaseString
        self.type = type
        self.reading = reading
        self.unit = unit
        self.timestamp = timestamp
        self.estimated = false
    }
    
    override static func primaryKey() -> String? {
        return "objectID"
    }
}

class Rate: Object {
    dynamic var objectID = ""
    dynamic var unit:Int = 0
    dynamic var wef:NSDate = NSDate.distantPast()
    dynamic var provider:Int = 0
    
    convenience init(unit:Int, wef:NSDate, provider:Int) {
        self.init()
        objectID = NSUUID().UUIDString.lowercaseString
        self.unit = unit
        self.wef = wef
        self.provider = provider
    }
    
    override static func primaryKey() -> String? {
        return "objectID"
    }
}

class Account: Object {
    dynamic var objectID = ""
    let meters = List<Meter>()
    
    override static func primaryKey() -> String? {
        return "objectID"
    }
    
    func addMeter(meter:Meter) {
        if (!meters.contains(meter)) {
            try! realm!.write {
                meters.append(meter)
            }
        }
    }
    
    func removeMeter(meter:Meter) {
        if meters.contains(meter) {
            try! realm!.write {
                realm!.delete(meter)
            }
        }
    }
}
