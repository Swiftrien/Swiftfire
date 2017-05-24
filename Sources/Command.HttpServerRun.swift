// =====================================================================================================================
//
//  File:       Command.HttpServerRun.swift
//  Project:    Swiftfire
//
//  Version:    0.10.7
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
// 0.10.7 - Merged SwiftfireCore into Swiftfire
// 0.10.6 - Update of server telemetry type
// 0.10.0 - Renamed HttpConnection to SFConnection
//        - Added logging of setup after start
//        - Renamed file from MacCommand to Command
// 0.9.18 - Renamed from Start to Run
//        - Header update
//        - Added serverErrorHandler
//        - Replaced log by Log?
// 0.9.15 - General update and switch to frameworks
// 0.9.14 - Initial release
//
// =====================================================================================================================

import Foundation
import SwifterLog
import SwifterJSON
import SecureSockets
import SwifterSockets

private let COMMAND_NAME = "HttpServerRunCommand"


/// Start http server operations.

public final class HttpServerRunCommand: MacMessage {
    
    
    /// Serialize this object.
    
    public var json: VJson {
        let j = VJson()
        j[COMMAND_NAME].nullValue = true
        return j
    }
    
    
    /// Deserialize an object.
    ///
    /// - Parameter json: The VJson hierarchy to be deserialized.
    
    public init?(json: VJson?) {
        guard let json = json else { return nil }
        guard (json|COMMAND_NAME)?.nullValue == true else { return nil }
    }
    
    
    /// The queue on which the server will accept client connection requests
    /*
    private static let acceptQueue: DispatchQueue = DispatchQueue(
        label: "Http Accept queue",
        qos: .userInteractive,
        attributes: DispatchQueue.Attributes(),
        autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit,
        target: nil)
    
    */
    /// Creates a new command.
    
    public init() {}
}


fileprivate func serverErrorHandler(message: String) { Log.atError?.log(id: -1, source: "HTTP Server", message: message) }


extension HttpServerRunCommand: MacCommand {
        
    public static func factory(json: VJson?) -> MacCommand? {
        return HttpServerRunCommand(json: json)
    }
        
    public func execute() {
        
        
        // If the server is running, don't do anything
        
        if httpServer?.isRunning ?? false { telemetry.httpServerStatus.value = "Running"; return }
        
        
        // If the https server is not running either, then reinit the available connections and domain services
        
        if !(httpsServer?.isRunning ?? false) {
            
            
            // Reset available connections
        
            connectionPool.create(num: parameters.maxNofAcceptedConnections.value, generator: { return SFConnection() })
        
            Log.atNotice?.log(id: -1, source: #file.source(#function, #line), message: "Initialized the connection pool with \(parameters.maxNofAcceptedConnections) http connections")
            
            
            // Rebuild the available services for the domains
            
            domains.forEach(){ $0.rebuildServices() }
        }


        // Restart the HTTP server
        
        httpServer = SwifterSockets.TipServer(
            .port(parameters.httpServicePortNumber.value),
            .maxPendingConnectionRequests(Int(parameters.maxNofPendingConnections.value)),
            .acceptQueue(httpServerAcceptQueue),
            .connectionObjectFactory(httpConnectionFactory),
            .acceptLoopDuration(2),
            .errorHandler(serverErrorHandler))
        
        switch httpServer?.start() {
            
        case nil:
                
            Log.atCritical?.log(id: -1, source: #file.source(#function, #line), message: "No HTTP server created")
            telemetry.httpServerStatus.value = "Cannot"
            
            
        case let .error(message)?:
                
            Log.atError?.log(id: -1, source: #file.source(#function, #line), message: message)
            telemetry.httpServerStatus.value = "Error"
            
            
        case .success?:
            
            Log.atNotice?.log(id: -1, source: #file.source(#function, #line), message: "HTTP Server started on port \(parameters.httpServicePortNumber)")
            
            // Log the conditions the server is running under
            
            logServerSetup()
            
            telemetry.httpServerStatus.value = "Running"
        }
        

        Log.atNotice?.log(id: -1, source: #file.source(#function, #line), message: "Completed")
    }
}
