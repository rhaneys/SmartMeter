//
//  RealmSmartMeter.swift
//  SmartMeter
//
//  Created by Richard Yip on 16/12/16.
//  Copyright © 2016 Richard Yip. All rights reserved.
//

import Realm

class RealmSmartMeter: NSObject{
    static let bundleVersionString: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
    static let numericSet : [Character] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    static let filteredCharacters = bundleVersionString.characters.filter {
        return numericSet.contains($0)
    }
    static let filteredString = String(filteredCharacters)
    var currentSchemaVersion: UInt64? = UInt64(filteredString)
    
    static let sharedInstance = RealmSmartMeter()
    private override init() {} //This prevents others from using the default '()' initializer for this class.

 
    private func deleteRealmFiles() {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        realm.deleteAllObjects()
        try! realm.commitWriteTransaction()
        
        if let realmURL = RLMRealmConfiguration.defaultConfiguration().fileURL {
            let realmURLs = [
                realmURL,
                realmURL.URLByAppendingPathExtension("lock"),
                realmURL.URLByAppendingPathExtension("log_a"),
                realmURL.URLByAppendingPathExtension("log_b"),
                realmURL.URLByAppendingPathExtension("note"),
                ]
            let manager = NSFileManager.defaultManager()
            for URL in realmURLs {
                do {
                    try manager.removeItemAtURL(URL!)
                } catch {
                    // handle error
                }
            }
        }
    }

    /**
     Give each account its own Realm file that will be used as the default Realm
     Using bundle version for time being,  later will using user's credentials
     @param username : use user's email as the file name
     */
    private func setDefaultRealmForUser() {
        
        let config = RLMRealmConfiguration.defaultConfiguration()
        let bundleVersionString: String = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as! String
        
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.URLByDeletingLastPathComponent?.URLByAppendingPathComponent("\(bundleVersionString).realm")
        
        #if !DEBUG
            config.encryptionKey = getKey(bundleVersionString)
        #endif
        
        // Database migration
        config.schemaVersion = currentSchemaVersion!
        config.deleteRealmIfMigrationNeeded = true
        
        // Set the block which will be called automatically when opening a Realm with a
        // schema version lower than the one set above
        config.migrationBlock = {(migration: RLMMigration, oldSchemaVersion: UInt64) in
            if oldSchemaVersion < self.currentSchemaVersion {
            }
        }
        
        // Set this as the configuration used for the default Realm
        RLMRealmConfiguration.setDefaultConfiguration(config)
        
        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        
        RLMRealm.defaultRealm()
        //        try! RLMRealm.defaultRealm().writeCopyToURL(config.fileURL!, encryptionKey: config.encryptionKey)
        
    }

    private func getKey(bareJID: String) -> NSData {
        // Identifier for our keychain entry - should be unique for your application
        
        let keychainIdentifier = bareJID
        let keychainIdentifierData = keychainIdentifier.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!
        
        // First check in the keychain for an existing key
        var query: [NSString: AnyObject] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData,
            kSecAttrKeySizeInBits: 512,
            kSecReturnData: true
        ]
        
        // To avoid Swift optimization bug, should use withUnsafeMutablePointer() function to retrieve the keychain item
        // See also: http://stackoverflow.com/questions/24145838/querying-ios-keychain-using-swift/27721328#27721328
        var dataTypeRef: AnyObject?
        var status = withUnsafeMutablePointer(&dataTypeRef) { SecItemCopyMatching(query, UnsafeMutablePointer($0)) }
        if status == errSecSuccess {
            return dataTypeRef as! NSData
        }
        
        // No pre-existing key from this application, so generate a new one
        let keyData = NSMutableData(length: 64)!
        let result = SecRandomCopyBytes(kSecRandomDefault, 64, UnsafeMutablePointer<UInt8>(keyData.mutableBytes))
        assert(result == 0, "Failed to get random bytes")
        
        // Store the key in the keychain
        query = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: keychainIdentifierData,
            kSecAttrKeySizeInBits: 512,
            kSecValueData: keyData
        ]
        
        status = SecItemAdd(query, nil)
        assert(status == errSecSuccess, "Failed to insert the new key in the keychain")
        
        return keyData
    }
    
    func register() {
        _ = RLMRealm.defaultRealm()

    }

}



