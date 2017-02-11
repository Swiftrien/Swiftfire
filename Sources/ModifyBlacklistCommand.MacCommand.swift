// =====================================================================================================================
//
//  File:       ModifyBlacklistCommand.MacCommand.swift
//  Project:    Swiftfire
//
//  Version:    0.9.15
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/
//  Blog:       http://swiftrien.blogspot.com
//  Git:        https://github.com/Balancingrock/Swiftfire
//
//  Copyright:  (c) 2016-2017 Marinus van der Lugt, All rights reserved.
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
//  I strongly believe that the Non Agression Principle is the way for societies to function optimally. I thus reject
//  the implicit use of force to extract payment. Since I cannot negotiate with you about the price of this code, I
//  have choosen to leave it up to you to determine its price. You pay me whatever you think this code is worth to you.
//
//   - You can send payment via paypal to: sales@balancingrock.nl
//   - Or wire bitcoins to: 1GacSREBxPy1yskLMc9de2nofNv2SNdwqH
//
//  I prefer the above two, but if these options don't suit you, you can also send me a gift from my amazon.co.uk
//  wishlist: http://www.amazon.co.uk/gp/registry/wishlist/34GNMPZKAQ0OO/ref=cm_sw_em_r_wsl_cE3Tub013CKN6_wb
//
//  If you like to pay in another way, please contact me at rien@balancingrock.nl
//
//  (It is always a good idea to visit the website/blog/google to ensure that you actually pay me and not some imposter)
//
//  For private and non-profit use the suggested price is the price of 1 good cup of coffee, say $4.
//  For commercial use the suggested price is the price of 1 good meal, say $20.
//
//  You are however encouraged to pay more ;-)
//
//  Prices/Quotes for support, modifications or enhancements can be obtained from: rien@balancingrock.nl
//
// =====================================================================================================================
// PLEASE let me know about bugs, improvements and feature requests. (rien@balancingrock.nl)
// =====================================================================================================================
//
// History
//
// v0.9.15 - General update and switch to frameworks
// v0.9.14 - Initial release
// =====================================================================================================================

import Foundation
import SwifterJSON
import SwifterLog


extension ModifyBlacklistCommand: MacCommand {
    
    static func factory(json: VJson?) -> MacCommand? {
        return ModifyBlacklistCommand(json: json)
    }
    
    func execute() {
        
        log.atLevelNotice(id: -1, source: #file.source(#function, #line))
        
        guard let bAction = Blacklist.Action(rawValue: action) else {
            log.atLevelError(id: -1, source: #file.source(#function, #line), message: "Cannot create Action type from '\(action)'")
            return
        }
        
        if source == "Server" {
            if remove {
                serverBlacklist.remove(ipAddress: address)
            }
            else {
                serverBlacklist.add(ipAddress: address, action: bAction)
            }
            let reply = ReadBlacklistReply(source: "Server", list: serverBlacklist)
            mac?.transfer(reply)
        }
        else {
            if let domain = domains.domain(forName: source) {
                if remove {
                    domain.blacklist.remove(ipAddress: address)
                }
                else {
                    domain.blacklist.add(ipAddress: address, action: bAction)
                }
                let reply = ReadBlacklistReply(source: source, list: domain.blacklist)
                mac?.transfer(reply)
            }
        }
    }
}