// =====================================================================================================================
//
//  File:       Parameters.swift
//  Project:    Swiftfire
//
//  Version:    1.0.0
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/
//  Git:        https://github.com/Balancingrock/Swiftfire
//
//  Copyright:  (c) 2014-2019 Marinus van der Lugt, All rights reserved.
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
import VJson
import SwifterLog
import BRUtils


final class ServerParameters {

    
    /// When this variable is "true" additional code is executed to generate (a lot of) debug information
    ///
    /// - Note: This variable is independant of the logging levels
    ///
    /// Debug: false
    
    let debugMode = NamedBoolValue(
        name: "DebugMode",
        about: "Will generate extra debug information when true",
        value: false,
        resetValue: false)
    
    
    /// This is the port number upon which http requests will be accepted
    ///
    /// Default: 6678

    let httpServicePortNumber = NamedStringValue(
        name: "HttpServicePortNumber",
        about: "The port number on which HTTP requests will be accepted",
        value: "6678",
        resetValue: "6678")

    
    /// This is the port number upon which https requests will be accepted
    ///
    /// Default: 6679
    
    let httpsServicePortNumber = NamedStringValue(
        name: "HttpsServicePortNumber",
        about: "The port number on which HTTPS requests will be accepted",
        value: "6679",
        resetValue: "6679")
    
    
    /// This is the maximum number of (parralel) http connection requests that Swiftfire accepts. Any more than this will become pending.
    ///
    /// Default: 20

    let maxNofAcceptedConnections = NamedIntValue(
        name: "MaxNofAcceptedConnections",
        about: "The maximum number of concurrent HTTP and/or HTTPS requests accepted",
        value: 20,
        resetValue: 20)
    
    
    /// This is the maximum number of http connection requests that are kept pending. Any more than this and will be rejected.
    ///
    /// Default: 20

    let maxNofPendingConnections = NamedIntValue(
        name: "MaxNofPendingConnections",
        about: "The maximum number of HTTP and HTTPS requests accepted",
        value: 20,
        resetValue: 20)
    
    
    /// This is the maximum time a pending connection request is kept waiting before it is rejected.
    ///
    /// Default: 30 [Seconds]

    let maxWaitForPendingConnections = NamedIntValue(
        name: "MaxWaitForPendingConnections",
        about: "The maximum duration for a request to be kept pending [Sec]",
        value: 30,
        resetValue: 30)
    
    
    /// The maximum size of a http message that can be received from client.
    ///
    /// Default: 32 * 1024 [bytes]

    let clientMessageBufferSize = NamedIntValue(
        name: "ClientMessageBufferSize",
        about: "The maximum size of a HTTP(S) request message [bytes]",
        value: 32 * 1024,
        resetValue: 32 * 1024)
    
    
    /// When a HTTP request has the "keep alive" option set, the connection will remain open for this time after the last data block was processed from that client.
    ///
    /// Default: 500 [mSec]

    let httpKeepAliveInactivityTimeout = NamedIntValue(
        name: "HttpKeepAliveInactivityTimeout",
        about: "The time a keep-alive request will be honoured [mSec]",
        value: 500,
        resetValue: 500)
    
    
    /// When data has to be transferred to a client, this is the timeout for the transmit operation.
    ///
    /// Default: 10 [Sec]

    let httpResponseClientTimeout = NamedIntValue(
        name: "HttpResponseClientTimeout",
        about: "The timeout for replies to a client [Sec]",
        value: 10,
        resetValue: 10)
    
    
    /// The OS Log threshold, logging information at this level (or above) will be written to the OS Log
    ///
    /// Default: 2 = SwifterLog.Level.notice

    let osLogRecordAtAndAboveLevel = NamedIntValue(
        name: "OsLogLevel",
        about: "The minimum loglevel for entries written to the os log [0..8].",
        value: 8,
        resetValue: 2)
    
    
    /// The stdout threshold, logging information at this level (or above) will be written to stdout (terminal/xcode console)
    ///
    /// Default: 8 = SwifterLog.Level.none
    
    let stdoutPrintAtAndAboveLevel = NamedIntValue(
        name: "StdoutLogLevel",
        about: "The minimum loglevel for entries written to STDOUT [0..8].",
        value: 0,
        resetValue: 8)
    
    
    /// The callback threshold, logging information at this level (or above) will be send to the registered callbacks.
    ///
    /// Default: 8 = SwifterLog.Level.none

    let callbackAtAndAboveLevel = NamedIntValue(
        name: "CallbackLogLevel",
        about: "The minimum loglevel for the callback destination(s) [0..8].",
        value: 8,
        resetValue: 8)
    
    
    /// The file logging threshold, logging information at this level (or above) will be written to the logfile.
    ///
    /// Default: 8 = SwifterLog.Level.none

    let fileRecordAtAndAboveLevel = NamedIntValue(
        name: "FileLogLevel",
        about: "The minimum loglevel for entries written to file [0..8].",
        value: 8,
        resetValue: 8)
    
    
    /// The maximum size of a single logfile (in kbytes)
    ///
    /// 1000 [KByte]

    let logfileMaxSize = NamedIntValue(
        name: "LogfileMaxSize",
        about: "The (about) maximum size of a single longfile [KByte].",
        value: 1000,
        resetValue: 1000)
    
    
    /// The maximum number of logfiles that will be kept in the logfile directory
    ///
    /// Default: 20

    let logfileMaxNofFiles = NamedIntValue(
        name: "LogfileMaxNofFiles",
        about: "The maximum number of logfiles.",
        value: 20,
        resetValue: 20)
    
    
    /// The network target threshold, logging information at this level (or above) will be sent to the network destination.
    ///
    /// Default: 8 = SwifterLog.Level.none

    let networkTransmitAtAndAboveLevel = NamedIntValue(
        name: "NetworkLogLevel",
        about: "The minimum loglevel for the network destination [0..8].",
        value: 8,
        resetValue: 8)
    
    
    /// The IP Address for the network logging target
    ///
    /// Default = ""
    
    let networkLogtargetIpAddress = NamedStringValue(
        name: "NetworkLogTargetAddress",
        about: "The IP address for a network log destination.",
        value: "",
        resetValue: "")
    
    
    /// The port number for the network logging target
    ///
    /// Default = ""
    
    let networkLogtargetPortNumber = NamedStringValue(
        name: "NetworkLogTargetPort",
        about: "The port number for a network log destination.",
        value: "",
        resetValue: "")
    
    
    /// Enables/Disables logging of all request headers
    ///
    /// Default: false

    let headerLoggingEnabled = NamedBoolValue(
        name: "HeaderLoggingEnabled",
        about: "Enables/Disables header logging at the server wide level.",
        value: false,
        resetValue: false)
    
    
    /// The maximum file size for header logging (in kbytes)
    ///
    /// Default: 1000 [KByte]

    let maxFileSizeForHeaderLogging = NamedIntValue(
        name: "MaxFileSizeForHeaderLogging",
        about: "The (about) maximum filesize for the server wide headerlog file. [KByte]",
        value: 1000,
        resetValue: 1000)
    
    
    /// Synchronize the header logging file after each write
    ///
    /// Default: false

    let flushHeaderLogfileAfterEachWrite = NamedBoolValue(
        name: "FlushHeaderLogfileAfterEachWrite",
        about: "Ensures that the header logfile is written to disk after each entry.",
        value: false,
        resetValue: false)

    
    /// The domain name for http 1.0 requests
    ///
    /// Default: ""
    
    let http1_0DomainName = NamedStringValue(
        name: "Http1_0DomainName",
        about: "The domain for HTTP(S) 1.0 requests",
        value: "",
        resetValue: "")
    
    
    /// The cache size of the SFDocument cache in MB
    ///
    /// Default: 100 [MByte]
    
    let sfDocumentCacheSize = NamedIntValue(
        name: "SFDocumentCacheSize",
        about: "The size of the SF document cache size [MB]",
        value: 100,
        resetValue: 100)
    
    
    /// The root of the server admin site
    ///
    /// Default: None.
    
    let adminSiteRoot = NamedStringValue(
        name: "ServerAdminSiteRoot",
        about: "The root directory for the server admin site",
        value: "",
        resetValue: "")
    
    
    /// All parameters
    
    private(set) var all: Array<NamedValueProtocol> = []
    
    
    /// Create a new object.

    init() {
        
        // Note: No literal array used because of compilation times.

        all.append(httpServicePortNumber)
        all.append(httpsServicePortNumber)
        all.append(maxNofAcceptedConnections)
        all.append(maxNofPendingConnections)
        all.append(maxWaitForPendingConnections)
        all.append(clientMessageBufferSize)
        all.append(httpKeepAliveInactivityTimeout)
        all.append(httpResponseClientTimeout)
        all.append(debugMode)
        all.append(osLogRecordAtAndAboveLevel)
        all.append(stdoutPrintAtAndAboveLevel)
        all.append(fileRecordAtAndAboveLevel)
        all.append(callbackAtAndAboveLevel)
        all.append(networkTransmitAtAndAboveLevel)
        all.append(networkLogtargetIpAddress)
        all.append(networkLogtargetPortNumber)
        all.append(logfileMaxSize)
        all.append(logfileMaxNofFiles)
        all.append(maxFileSizeForHeaderLogging)
        all.append(headerLoggingEnabled)
        all.append(flushHeaderLogfileAfterEachWrite)
        all.append(http1_0DomainName)
        all.append(sfDocumentCacheSize)
        all.append(adminSiteRoot)
    }
}


// MARK: - Storage

extension ServerParameters {
    
    /// Updates the parameter values from the parameter-defaults.json file if that file exists. It only updates those values that are found in the defaults file. All other parameters remain at their hard-coded default values. Parameters found in the defaults file that are not (no longer?) used will be flagged as errors in the log.
    
    func restore(fromFile url: URL) -> Result<String> {
                
        
        // Does the parameter defaults file exist?
        
        guard url.isFileURL && FileManager.default.fileExists(atPath: url.path) else {
            return .success("No 'parameter-defaults.json' file present, starting with hard coded defaults.")
        }

        
        // Parse the parameter defaults file
        
        guard let j = ((try? VJson.parse(file: url)) as VJson??), let json = j else {
            return .error(message: "Could not retrieve JSON code from parameter-defaults file.")
        }

        
        // Update the parameters
        
        var message = ""
        for item in all {
            if let strval = (json|item.name)?.stringValue {
                if item.setValue(strval) {
                    json.removeItems(forName: item.name)
                } else {
                    message += "Failed to set value for \(item.name) to \(strval)\n"
                }
            } else {
                message += "Missing value for \(item.name)\n"
            }
        }
        if message != "" { return .error(message: message) }
            
        if json.nofChildren != 0 {
            return .error(message: "Superfluous items in source: \(json.code)")
        }

        
        return .success(message)
    }
    
    
    /// Save the parameter dictionary contents to the 'domains-default.json' file.

    func save(toFile url: URL) {
        
        let json = VJson()
        all.forEach({
            json[$0.name] &= $0.stringValue
        })
        json.save(to: url)
    }
}


// MARK: - CustomStringConvertible

extension ServerParameters: CustomStringConvertible {
    
    var description: String {
        var str = "Parameters:\n"
        str += all.map({ " \($0.name) = \($0.stringValue)" }).joined(separator: "\n")
        return str
    }
}


func setupParametersDidSetActions() {
    
    parameters.osLogRecordAtAndAboveLevel.addDidSetAction {
        if let level = SwifterLog.Level.factory(parameters.osLogRecordAtAndAboveLevel.value) {
            Log.singleton.osLogFacilityRecordAtAndAboveLevel = level
        } else {
            Log.atError?.log("Cannot create loglevel from \(parameters.osLogRecordAtAndAboveLevel.value) for osLogRecordAtAndAboveLevel")
        }
    }
    
    parameters.fileRecordAtAndAboveLevel.addDidSetAction {
        if let level = SwifterLog.Level.factory(parameters.fileRecordAtAndAboveLevel.value) {
            Log.singleton.fileRecordAtAndAboveLevel = level
        } else {
            Log.atError?.log("Cannot create loglevel from \(parameters.fileRecordAtAndAboveLevel.value) for fileRecordAtAndAboveLevel")
        }
    }
    
    parameters.callbackAtAndAboveLevel.addDidSetAction {
        if let level = SwifterLog.Level.factory(parameters.callbackAtAndAboveLevel.value) {
            Log.singleton.callbackAtAndAboveLevel = level
        } else {
            Log.atError?.log("Cannot create loglevel from \(parameters.callbackAtAndAboveLevel.value) for callbackAtAndAboveLevel")
        }
    }
    
    parameters.stdoutPrintAtAndAboveLevel.addDidSetAction {
        if let level = SwifterLog.Level.factory(parameters.stdoutPrintAtAndAboveLevel.value) {
            Log.singleton.stdoutPrintAtAndAboveLevel = level
        } else {
            Log.atError?.log("Cannot create loglevel from \(parameters.stdoutPrintAtAndAboveLevel.value) for stdoutPrintAtAndAboveLevel")
        }
    }
    
    parameters.networkTransmitAtAndAboveLevel.addDidSetAction {
        if let level = SwifterLog.Level.factory(parameters.networkTransmitAtAndAboveLevel.value) {
            Log.singleton.networkTransmitAtAndAboveLevel = level
        } else {
            Log.atError?.log("Cannot create loglevel from \(parameters.networkTransmitAtAndAboveLevel.value) for networkTransmitAtAndAboveLevel")
        }
    }
}

