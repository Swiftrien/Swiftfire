// =====================================================================================================================
//
//  File:       Service.OnlyGetOrPost.swift
//  Project:    Swiftfire
//
//  Version:    0.10.0
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/
//  Blog:       http://swiftrien.blogspot.com
//  Git:        https://github.com/Balancingrock/Swiftfire
//
//  Copyright:  (c) 2017 Marinus van der Lugt, All rights reserved.
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
//  I strongly believe that voluntarism is the way for societies to function optimally. Thus I have choosen to leave it
//  up to you to determine the price for this code. You pay me whatever you think this code is worth to you.
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
// 0.10.0 - Renamed HttpConnection to SFConnection
//        - Renamed from DomainService to Service
// 0.9.18 - Header update
//        - Replaced log with Log?
// 0.9.15 - Initial release
//
// =====================================================================================================================
// Description
// =====================================================================================================================
//
// Examines the request header and create an error code if the header contains neither GET or POST operation.
//
// If a response.code is set, this operation exists immediately with .continueChain.
//
//
// Input:
// ------
//
// header.httpVersion: The version of the http request header.
// response.code: If set, this service will exit immediately with .continueChain'.
//
//
// On success:
// -----------
//
// return: .continueChain
//
//
// On error: Missing operation specification
// -----------------------------------------
// response.code: code 400 (Bad Request) if the HTTP request contains no operation.
// domain.telemetry.nof400: incremented
// statistics: Updated with a ClientRecord.
//
// return: .continueChain
//
//
// On error: Neither a GET nor POST operation
// ------------------------------------------
// - code 501 (Not Supported) if the HTTP request contains neither GET nor POST operation
// - domain.telemetry.nof501: incremented
// - statistics: Updated with a ClientRecord.
//
// return: .continueChain
//
// =====================================================================================================================

import Foundation
import SwifterLog
import SwiftfireCore
import SwifterSockets


/// Generate an error code if the request is not GET or POST operation.
///
/// - Note: For a full description of all effects of this operation see the file: DomainService.GetResourcePathFromUrl.swift
///
/// - Parameters:
///   - header: The header of the HTTP request.
///   - body: The data that accompanied the HTTP request (if any).
///   - connection: The HttpConnection object that is used for this connection.
///   - domain: The domain that is serviced for this request.
///   - chainInfo: A dictionary for communication between services.
///   - response: An object that can receive information to be returned in response to the request.
///
/// - Returns: On error .abortChain, on success .continueChain.

func ds_onlyGetOrPost(_ header: HttpHeader, _ body: Data?, _ connection: Connection, _ domain: Domain, _ chainInfo: inout Service.ChainInfo, _ response: inout Service.Response) -> Service.Result {
    
    
    // Abort immediately if there is already a response code
    
    if response.code != nil { return .continueChain }

    
    // =============================================================================================================
    // It must be either a GET or POST operation
    // =============================================================================================================
    
    guard let operation = header.operation else {
        
        
        // Telemetry update
        
        domain.telemetry.nof400.increment()
        
        
        // Aliases
        
        let connection = (connection as! SFConnection)
        let logId = connection.interface?.logId ?? -2

        
        // Log update
        
        let message = "Could not extract operation"
        Log.atDebug?.log(id: logId, source: #file.source(#function, #line), message: message)
        
        
        // Mutation update
        
        let mutation = Mutation.createAddClientRecord(from: connection)
        mutation.httpResponseCode = HttpResponseCode.code400_BadRequest.rawValue
        mutation.responseDetails = message
        mutation.requestReceived = chainInfo[Service.ChainInfoKey.responseStartedKey] as? Int64 ?? 0
        statistics.submit(mutation: mutation, onError: {
            (message: String) in
            Log.atError?.log(id: connection.logId, source: #file.source(#function, #line), message: "Error during statistics submission:\(message)")
        })
        
        
        // Response
        
        response.code = HttpResponseCode.code400_BadRequest
        return .continueChain
    }

    
    // =============================================================================================================
    // It must be either a GET or POST operation
    // =============================================================================================================

    guard (operation == HttpOperation.get || operation == HttpOperation.post) else {
        
        
        // Telemetry update
        
        domain.telemetry.nof501.increment()
        
        
        // Aliases
        
        let connection = (connection as! SFConnection)
        let logId = connection.interface?.logId ?? -2

        
        // Log update
        
        let message = "Operation '\(operation.rawValue)' not supported)"
        Log.atDebug?.log(id: logId, source: #file.source(#function, #line), message: message)
        
        
        // Mutation update
        
        let mutation = Mutation.createAddClientRecord(from: connection)
        mutation.httpResponseCode = HttpResponseCode.code501_NotImplemented.rawValue
        mutation.responseDetails = message
        mutation.requestReceived = chainInfo[Service.ChainInfoKey.responseStartedKey] as? Int64 ?? 0
        statistics.submit(mutation: mutation, onError: {
            (message: String) in
            Log.atError?.log(id: connection.logId, source: #file.source(#function, #line), message: "Error during statistics submission:\(message)")
        })
        
        
        // Response
        
        response.code = HttpResponseCode.code501_NotImplemented
        return .continueChain
    }

    return .continueChain
}
