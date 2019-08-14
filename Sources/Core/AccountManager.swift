// =====================================================================================================================
//
//  File:       AccountManager.swift
//  Project:    Swiftfire
//
//  Version:    1.0.0
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/
//  Git:        https://github.com/Balancingrock/Swiftfire
//
//  Copyright:  (c) 2017-2019 Marinus van der Lugt, All rights reserved.
//
//  License:    Use or redistribute this code any way you like with the following two provision:
//
//  1) You ACCEPT this source code AS IS without any guarantees that it will work as intended. Any liability from its
//  use is YOURS.
//
//  2) You WILL NOT seek damages from the author or balancingrock.nl.
//
//  I also ask you to please leave this header with the source code.
//
//  Like you, I need to make a living:
//
//   - You can send payment (you choose the amount) via paypal to: sales@balancingrock.nl
//   - Or wire bitcoins to: 1GacSREBxPy1yskLMc9de2nofNv2SNdwqH
//
//  If you like to pay in another way, please contact me at rien@balancingrock.nl
//
//  Prices/Quotes for support, modifications or enhancements can be obtained from: rien@balancingrock.nl
//
// =====================================================================================================================
// PLEASE let me know about bugs, improvements and feature requests. (again: rien@balancingrock.nl)
// =====================================================================================================================
//
// History
//
// 1.0.0 Raised to v1.0.0, Removed old change log,
//
// =====================================================================================================================

import Foundation


import KeyedCache
import VJson



public class AccountManager {
    
    
    // The queue for concurrent access protection
    
    private static var queue = DispatchQueue(
        label: "Accounts",
        qos: DispatchQoS.default,
        attributes: DispatchQueue.Attributes(),
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
        target: nil
    )
    
    
    /// Create an account directory url from the given account ID relative to the given root url
    ///
    /// Example 1: id 2345 will result in: root/45/23/_Account/
    ///
    /// Example 2: id 12345 will result in: root/45/23/01/_Account/
    
    private static func createDirUrl(in accountsRoot: URL, for id: Int) -> URL {
        
        
        // The account number will be broken up into reverse series of 0..99 (centi) fractions
        
        var centiFractions: Array<Int> = []
        
        var num = id
        
        while num >= 100 {
            centiFractions.append(num % 100)
            num = num / 100
        }
        centiFractions.append(num)
        
        
        // Convert the centi parts to string
        
        let centiFractionsStr = centiFractions.map({ (num) -> String in
            if num < 10 {
                return "0\(num)"
            } else {
                return num.description
            }
        })
        
        
        // And create the directory url
        
        var url = accountsRoot
        centiFractionsStr.forEach({ url.appendPathComponent($0) })
        url.appendPathComponent("_Account") // The underscore is for reasons of sorting in the finder
        
        try? FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        
        return url
    }

    
    /// The root folder for all accounts
    
    private var root: URL!
    
    
    /// The file for the lookup table that associates an account name with an account id
    
    private var lutFile: URL {
        return root.appendingPathComponent("AccountsLut").appendingPathExtension("json")
    }
    
    
    /// The lookup table that associates an account name with an account id
    
    private var nameLut: Dictionary<String, Int> = [:]
    
    
    /// The lookup table that associates an uuid with an account name
    
    private var uuidLut: Dictionary<String, String> = [:]
    
    
    /// The id of the last account created
    
    private var lastAccountId: Int = 0
    
    
    /// The number of accounts
    
    public var count: Int { return nameLut.count }
    
    
    /// Returns 'true' if there are no accounts yet
    
    public var isEmpty: Bool { return nameLut.isEmpty }
    
    
    /// The account cache
    
    private var accountCache: MemoryCache = MemoryCache<String, Account>(limitStrategy: .byItems(100), purgeStrategy: .leastRecentUsed)
    
    
    /// Initialize from file
    
    public init?(directory: URL?) {
        guard let directory = directory else { return nil }
        self.root = directory
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: lutFile.path, isDirectory: &isDir) && !isDir.boolValue {
            loadLuts()
        } else {
            if regenerateLuts() {
                storeLuts()
            }
        }
    }
    
}


// MARK: - Storage

extension AccountManager {
    
    
    /// Save the accounts
    
    public func store() { storeLuts() }
    
    
    /// Load the lookup tables from file
    
    private func loadLuts() {
        
        if let json = VJson.parse(file: lutFile, onError: { (_, _, _, mess) in
            Log.atCritical?.log("Failed to load accounts lookup table from \(self.lutFile.path), error message = \(mess)", type: "Accounts")
        }) {
            
            for item in json {
                if  let name = (item|"Name")?.stringValue,
                    let uuid = (item|"Uuid")?.stringValue,
                    let id = (item|"Id")?.intValue {
                    nameLut[name] = id
                    uuidLut[uuid] = name
                    if id > lastAccountId { lastAccountId = id }
                } else {
                    Log.atCritical?.log("Failed to load accounts lookup table from \(lutFile.path), error message = Cannot read name, uuid or id from entry \(item)")
                    return
                }
            }
        }
    }
    
    
    /// Save the lookup tables to file
    
    private func storeLuts() {
        
        var once = true // Prevents repeated entries in the log
        
        let json = VJson.array()
        
        uuidLut.forEach {
            (uuid, name) in
            if let id = nameLut[name] {
                let child = VJson()
                child["Name"] &= name
                child["Uuid"] &= uuid
                child["Id"] &= id
                json.append(child)
            } else {
                if once {
                    once = false
                    Log.atCritical?.log("Account lookup tables are damaged, possible account loss. Regenerate the luts to recover the accounts")
                }
            }
        }
        
        // Prevent saving of empty LUTs to avoid situations where an empty LUT prevents regeneration of LUT.
        // (This is a potential problem for admin accounts which would cause repeated requesting of admin credentials)
        
        if uuidLut.count > 0 { json.save(to: lutFile) }
    }
    
    
    /// Regenerates the lookup table from the contents on disk
    
    public func regenerateLuts() -> Bool {
        
        var nameLut: Dictionary<String, Int> = [:]
        var uuidLut: Dictionary<String, String> = [:]
        
        
        func processDirectory(dir: URL) -> Bool {
            
            let urls = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)
            
            if let urls = urls {
                
                for url in urls {
                    
                    // If the url is a directory, then process it (recursive), if it is a file, try to read it as an account.
                    
                    var isDir: ObjCBool = false
                    if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) && isDir.boolValue {
                        
                        if url.lastPathComponent == "_Account" {
                            
                            if let account = Account(withContentOfDirectory: url) {
                                nameLut[account.name] = account.id
                                uuidLut[account.uuid] = account.name
                            } else {
                                Log.atCritical?.log("Failed to read account from \(url.path)")
                                return false
                            }
                            
                        } else {
                            
                            if !processDirectory(dir: url) {
                                return false
                            }
                        }
                    }
                }
                
                return true
                
            } else {
                
                Log.atCritical?.log("Failed to read account directories from \(dir.path)")
                return false
            }
        }
        
        Log.atWarning?.log("Attempting to recreate account LUT from raw account data")
        
        if processDirectory(dir: root) {
            
            self.nameLut = nameLut
            self.uuidLut = uuidLut
            
            Log.atNotice?.log("Regenerated the account LUT")
            return true
            
        } else {
            
            Log.atCritical?.log("Could not recreate account LUT from raw account data, accounts may have been lost!")
            return false
        }
    }
}


// MARK: - Operational interface

extension AccountManager {
    
    
    /// Returns the account for the given name and password. First it will try to read the account from the cache. If the cache does not contain the account it will try to find it in the lookup table and if found, load it from file. The password hash must matches the account hash.
    ///
    /// - Parameters:
    ///   - for: The name of the account to find. May not be empty.
    ///   - using: The password over which to calculate the hash and compare it with the stored hash. May not be empty.
    ///
    /// - Returns: On success the account, otherwise nil.
    
    public func getAccount(for name: String, using password: String) -> Account? {
        
        
        // Only valid parameters
        
        if password.isEmpty { return nil }
        if name.isEmpty { return nil }
        
        return AccountManager.queue.sync {
            
            
            // Try to extract it from the cache
            
            var account = accountCache[name]
            
            if account == nil {
                
                // Check the lookup table
                
                if let id = nameLut[name] {
                    let dir = AccountManager.createDirUrl(in: root, for: id)
                    if let a = Account(withContentOfDirectory: dir) {
                        accountCache[name] = a
                        account = a
                    }
                }
            }
            
            
            // Was an existing account found?
            
            if account == nil { return nil }
            
            
            // Check the password
            
            if account?.hasSameDigest(as: password) ?? false {
                return account
            } else {
                return nil
            }
        }
    }
    
    
    /// Create a new account and adds it to the cache.
    ///
    /// - Parameters:
    ///   - name: The name for the account, cannot be empty.
    ///   - password: The password over which to determine the password hash, may not be empty.
    ///
    /// - Returns: Nil if the input parameters are invalid or if the account already exists. The new account if it was created.
    
    public func newAccount(name: String, password: String) -> Account? {
        
        return AccountManager.queue.sync {
            
            // Only valid parameters
            
            guard !password.isEmpty else { return nil }
            guard !name.isEmpty else { return nil }
            
            
            // Check if the account already exists
            
            if nameLut[name] != nil { return nil }
            
            
            // Create the new account
            
            lastAccountId += 1
            let adir = AccountManager.createDirUrl(in: root, for: lastAccountId)
            if let account = Account(id: lastAccountId, name: name, password: password, accountDir: adir) {
                
                
                // Add it to the lookup's and the cache
                
                uuidLut[account.uuid] = name
                nameLut[name] = lastAccountId
                accountCache[name] = account
                
                
                // Save the lut
                
                storeLuts()
                
                return account
                
            } else {
                
                Log.atError?.log()
                return nil
            }
        }
    }
    
    
    /// Checks if an account exists for the given uuid string.
    ///
    /// - Parameter uuid: The uuid of the account to test for.
    ///
    /// - Returns: True if the uuid is contained in this list. False otherwise.
    
    public func contains(_ uuid: String) -> Bool {
        return AccountManager.queue.sync {
            return uuidLut[uuid] != nil
        }
    }
    
    
    /// Checks if an account name is available.
    ///
    /// - Returns: True if the given name is available as an account name.
    
    public func available(name: String) -> Bool {
        return AccountManager.queue.sync {
            return nameLut[name] == nil
        }
    }
}
