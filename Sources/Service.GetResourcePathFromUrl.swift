// =====================================================================================================================
//
//  File:       Service.GetResourcePathFromUrl.swift
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
// Builds the resource path from the requested URL, the domain root directory and the presence of file candidates.
//
// If the root/url points at a directory, that directory will be tested for the presence of an index.htm or index.html
// file. If found, the resource path will be set to that file.
//
// If a response.code is set, this operation exists immediately with .continueChain.
//
//
// Input:
// ------
//
// response.code: If set, this service will exit immediately with .continueChain'.
// header.url: The string representing the URL of the resource to be found.
// domain.root: The string for the root directory of the domain.
// connection.filemanager: used.
//
//
// On success:
// -----------
//
// chainInfo[ResponsePathKey]: A string with the full path to an existing resource.
//
// return: .continueChain
//
//
// On error:
// ---------
//
// response.code:
//
// - code 400 (Bad Request) if the HTTP request header did not contain a url.
//   & domain.telemetry.nof400: incremented
//   & statistics: Updated with a ClientRecord.
//
// - code 404 (Not Found) if no resource (file) was present at the resource path.
//   & domain.telemetry.nof404: incremented
//   & statistics: Updated with a ClientRecord.
//
// - code 403 (Forbidden) if the file at the resource path is not readable.
//   & domain.telemetry.nof403: incremented
//   & statistics: Updated with a ClientRecord.
//
// return: .continueChain
//
// =====================================================================================================================

import Foundation
import SwifterLog
import SwiftfireCore
import SwifterSockets


/// Takes the URL from the request header and transforms it into a path that points at an existing resource
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

func ds_getResourcePathFromUrl(_ header: HttpHeader, _ body: Data?, _ connection: Connection, _ domain: Domain, _ chainInfo: inout Service.ChainInfo, _ response: inout Service.Response) -> Service.Result {
    
    
    func handle400_BadRequestError(message: String) {
        
        
        // Telemetry update
        
        domain.telemetry.nof400.increment()
        
        
        // Aliases
        
        let connection = (connection as! SFConnection)
        let logId = connection.interface?.logId ?? -2
        
        
        // Log update
        
        Log.atCritical?.log(id: logId, source: #file.source(#function, #line), message: message)
        
        
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
    }
    
    
    func handle404_NotFoundError(path: String) {
        
        
        // Telemetry update
        
        domain.telemetry.nof404.increment()
        
        
        // Aliases
        
        let connection = (connection as! SFConnection)

        
        // Conditional recording of all 404 path errors
        
        domain.recordIn404Log(path)
        

        // Mutation update
        
        let mutation = Mutation.createAddClientRecord(from: connection)
        mutation.httpResponseCode = HttpResponseCode.code404_NotFound.rawValue
        mutation.responseDetails = "Resource for url '\(path)' not found"
        mutation.requestReceived = chainInfo[Service.ChainInfoKey.responseStartedKey] as? Int64 ?? 0
        statistics.submit(mutation: mutation, onError: {
            (message: String) in
            Log.atError?.log(id: connection.logId, source: #file.source(#function, #line), message: "Error during statistics submission:\(message)")
        })
        
        
        // Response
        
        response.code = HttpResponseCode.code404_NotFound
    }

    
    func handle403_ForbiddenError(path: String) {
        
        
        // Telemetry update
        
        domain.telemetry.nof403.increment()
        
        
        // Aliases
        
        let connection = (connection as! SFConnection)
        
        
        // Mutation update
        
        let mutation = Mutation.createAddClientRecord(from: connection)
        mutation.httpResponseCode = HttpResponseCode.code403_Forbidden.rawValue
        mutation.responseDetails = "Access for url '\(path)' not allowed"
        mutation.requestReceived = chainInfo[Service.ChainInfoKey.responseStartedKey] as? Int64 ?? 0
        statistics.submit(mutation: mutation, onError: {
            (message: String) in
            Log.atError?.log(id: connection.logId, source: #file.source(#function, #line), message: "Error during statistics submission:\(message)")
        })
        
        
        // Response
        
        response.code = HttpResponseCode.code403_Forbidden
    }

    
    // Abort immediately if there is already a response code
    
    if response.code != nil { return .continueChain }

    
    // Aliases
    
    let connection = (connection as! SFConnection)

    
    // =============================================================================================================
    // Determine the resource path
    // =============================================================================================================
    
    guard let partialPath = header.url else {
        handle400_BadRequestError(message: "No URL in request")
        return .continueChain
    }
    
    
    // =============================================================================================================
    // Add the partial path to the root
    // =============================================================================================================
    
    let fullPath = (domain.root as NSString).appendingPathComponent(partialPath)

    
    // =============================================================================================================
    // Check if there is something at the full path, append index.htm or index.html when necessary
    // =============================================================================================================
    
    var isDirectory: ObjCBool = false
    
    if connection.filemanager.fileExists(atPath: fullPath, isDirectory: &isDirectory) {
        
        
        // There is something, if it is a directory, check for index.html or index.htm
        
        if isDirectory.boolValue {
            
            
            // Find a root-index file
            
            let acceptedIndexNames = ["index.html", "index.sf.html", "index.htm", "index.sf.htm"]
            
            for name in acceptedIndexNames {
                
                
                // Check for an 'index.html' file
                
                let tpath = (fullPath as NSString).appendingPathComponent(name)
                
                if connection.filemanager.isReadableFile(atPath: tpath) {
                    
                    chainInfo[Service.ChainInfoKey.absoluteResourcePathKey] = tpath as String
                    chainInfo[Service.ChainInfoKey.relativeResourcePathKey] = (partialPath as NSString).appendingPathComponent(name)
                    
                    return .continueChain
                }
            }
            
            
            // Neither file exists, and directory access is not allowed
            
            handle404_NotFoundError(path: partialPath)
            
            return .continueChain
            
            
        } else {
            
            // It is a file
            
            if connection.filemanager.isReadableFile(atPath: fullPath) {
                
                chainInfo[Service.ChainInfoKey.absoluteResourcePathKey] = fullPath
                chainInfo[Service.ChainInfoKey.relativeResourcePathKey] = partialPath
                
                return .continueChain
            
            } else {
            
                handle403_ForbiddenError(path: partialPath)

                return .continueChain
            }
        }
        
    } else {
        
        // If an "<name>.<ext>" file is requested, then check also for a "<name>.sf.<ext>" file

        func addSf(toPath: String) -> String? {
            let pathWithoutExtension = (toPath as NSString).deletingPathExtension
            let extensionPart = (toPath as NSString).pathExtension
            return ((pathWithoutExtension as NSString).appendingPathExtension("sf") as NSString?)?.appendingPathExtension(extensionPart)
        }
        
        if let sfFullPath = addSf(toPath: fullPath) {
        
            if connection.filemanager.fileExists(atPath: sfFullPath, isDirectory: &isDirectory) {
                
                if !isDirectory.boolValue {
                    
                    // It is a file
                    
                    if connection.filemanager.isReadableFile(atPath: sfFullPath) {
                        
                        chainInfo[Service.ChainInfoKey.absoluteResourcePathKey] = sfFullPath
                        
                        let sfPartialPath = addSf(toPath: partialPath) ?? partialPath // Default should never be used

                        chainInfo[Service.ChainInfoKey.relativeResourcePathKey] = sfPartialPath
                        
                        return .continueChain
                        
                        
                    } else {
                        
                        handle403_ForbiddenError(path: partialPath)
                        
                        return .continueChain
                    }
                }
            }
        }
        

        // There is nothing at the resource path
        
        handle404_NotFoundError(path: partialPath)
        
        return .continueChain
    }
}
