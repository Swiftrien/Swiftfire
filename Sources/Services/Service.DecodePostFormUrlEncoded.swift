// =====================================================================================================================
//
//  File:       Service.DecodePostFormUrlEncoded.swift
//  Project:    Swiftfire
//
//  Version:    1.0.1
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
// 1.0.1 - Documentation updates
// 1.0.0 - Raised to v1.0.0, Removed old change log,
//
// =====================================================================================================================

import Foundation
import SwifterLog
import SwifterSockets
import Http
import Core


/// Decodes the name/value pairs in the body of a post if the content type is set to 'application/x-www-form-urlencoding'. The name/value pairs are available afterwards in the postInfo directory.
///
/// _Input_:
///    - request.contentType: Only if set to 'application/x-www-form-urlencoding' (not checked!)
///    - request.payload: Should contain UTF8 encoded data.
///
/// _Output_:
///    - info[.postInfoKey] = Dictionary\<key, value\> with key = PostInfoKey and value = String. Containing all the name/value pairs found in the data part of the request. If no name/value pairs are available info[.postInfoKey] will be nil or an empty directory.
///
/// _Sequence_:
///    - The entire body of the request must be available, hence this service should come after the Service.WaitUntilBodyComplete.
///    - All services that need the postInfo dictionary should come after this service.

func service_decodePostFormUrlEncoded(_ request: Request, _ connection: SFConnection, _ domain: Domain, _ info: inout Services.Info, _ response: inout Response) -> Services.Result {
    
    
    // Abort immediately if there is already a response code
    
    if response.code != nil { return .next }
    
    
    // Check for data
    
    guard let strData = request.body, !strData.isEmpty else {
        Log.atDebug?.log("No data to decode.", id: connection.logId)
        return .next
    }
    
    
    // Convert data to string
    
    guard let str = String.init(data: strData, encoding: String.Encoding.utf8) else {
        Log.atDebug?.log("Cannot convert form urlencoded data to an UTF8 string", id: connection.logId)
        return .next
    }
    

    // Split into multiple name/value pairs
    
    let postInfo: PostInfo = PostInfo()
    
    var nameValuePairs = str.components(separatedBy: "&")
    
    while nameValuePairs.count > 0 {
        let nvPair = nameValuePairs.removeFirst()
        var nameValue = nvPair.components(separatedBy: "=")
        switch nameValue.count {
        case 0: break // error, don't do anything
        case 1: postInfo[nameValue[0]] = ""
        case 2: postInfo[nameValue[0]] = nameValue[1].removingPercentEncoding?.replacingOccurrences(of: "+", with: " ")
        default:
            let name = nameValue.removeFirst()
            postInfo[name] = nameValue.joined(separator: "=")
        }
    }
    
    
    // Add the post dictionary to the service info
    
    if postInfo.count > 0 { info[.postInfoKey] = postInfo }
    
    
    Log.atDebug?.log("Found \(postInfo.count) items", id: connection.logId)
    
    return .next
}

