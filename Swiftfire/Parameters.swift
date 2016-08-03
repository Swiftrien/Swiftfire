// =====================================================================================================================
//
//  File:       Parameters.swift
//  Project:    Swiftfire
//
private let VERSION = "0.9.13b1"
//
//  Author:     Marinus van der Lugt
//  Company:    http://balancingrock.nl
//  Website:    http://swiftfire.nl/
//  Blog:       http://swiftrien.blogspot.com
//  Git:        https://github.com/Swiftrien/Swiftfire
//
//  Copyright:  (c) 2014-2016 Marinus van der Lugt, All rights reserved.
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
//  whishlist: http://www.amazon.co.uk/gp/registry/wishlist/34GNMPZKAQ0OO/ref=cm_sw_em_r_wsl_cE3Tub013CKN6_wb
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
// v0.9.13 - Updated version number
//         - Simplified implementation
// v0.9.12 - Updated version number
// v0.9.11 - Updated version number
// v0.9.10 - Updated version number
// v0.9.9  - Updated version number
// v0.9.8  - Updated version number
// v0.9.7  - Changed initial value of HTTP_KEEP_ALIVE_INACTIVITY_TIMEOUT to 1 second
//         - Added HEADER_LOGGING_ENABLED, MAX_FILE_SIZE_FOR_HEADER_LOGGING, FLUSH_HEADER_LOGFILE_AFTER_EACH_WRITE
//         - Slightly optimized code to upgrade to new parameter file version
//         - Added function to upgrade to parameter version 2
//         - Moved M&C support for the server parameters to this file
// v0.9.6  - Header update & version number update
//         - Merged MAX_NOF_PENDING_CLIENT_MESSAGES with MAX_CLIENT_MESSAGE_SIZE into CLIENT_MESSAGE_BUFFER_SIZE
//         - Merged AutoStartup into this file
// v0.9.5  - Updated version number
// v0.9.4  - Updated version number
// v0.9.3  - Updated version number
// v0.9.2  - Updated version number
// v0.9.0  - Initial release
// =====================================================================================================================

import Foundation


// JSON identifiers (also used for logging)

private let DEBUG_MODE = "DebugMode"
private let SERVICE_PORT_NUMBER = "ServicePortNumber"
private let MAX_NOF_ACCEPTED_CONNECTIONS = "MaxNumberOfAcceptedConnections"
private let MAX_NOF_PENDING_CONNECTIONS = "MaxNumberOfPendingConnections"
private let MAX_WAIT_FOR_PENDING_CONNECTIONS = "MaxWaitForPendingConnections"
private let CLIENT_MESSAGE_BUFFER_SIZE = "ClienMessageBufferSize"
private let HTTP_KEEP_ALIVE_INACTIVITY_TIMEOUT = "HttpKeepAliveInactivityTimeout"
private let HTTP_RESPONSE_CLIENT_TIMEOUT = "HttpResponseClientTimeout"
private let MAC_INACTIVITY_TIMEOUT = "MacInactivityTimeout"
private let AUTO_STARTUP = "AutoStartup"
private let MAC_PORT_NUMBER = "MonitoringAndControlPortNumber"
private let ASL_FACILITY_RECORD_AT_AND_ABOVE_LEVEL = "AslFacilityRecordAtAndAboveLevel"
private let STDOUT_PRINT_AT_AND_ABOVE_LEVEL = "StdoutPrintAtAndAboveLevel"
private let CALLBACK_AT_AND_ABOVE_LEVEL = "CallbackAtAndAboveLevel"
private let FILE_RECORD_AT_AND_ABOVE_LEVEL = "FileRecordAtAndAboveLevel"
private let LOGFILE_MAX_SIZE = "LogfileMaxSize"
private let LOGFILE_MAX_NOF_FILES = "LogfileMaxNofFiles"
private let NETWORK_TRANSMIT_AT_AND_ABOVE_LEVEL = "NetworkTransmitAtAndAboveLevel"
private let NETWORK_LOGTARGET_IP_ADDRESS = "NetworkLogtargetIpAddress"
private let NETWORK_LOGTARGET_PORT_NUMBER = "NetworkLogtargetPortNumber"
private let HEADER_LOGGING_ENABLED = "HeaderLoggingEnabled"
private let MAX_FILE_SIZE_FOR_HEADER_LOGGING = "MaxFileSizeForHeaderLogging"
private let FLUSH_HEADER_LOGFILE_AFTER_EACH_WRITE = "FlushHeaderLogfileAfterEachWrite"


final class Parameters {

    
    /// The version number of Swiftfire
    
    static let version = VERSION // Always hard coded, never read from the parameter defaults file

    
    /// When this variable is "true" additional code may be executed to generate debug information
    /// - Note: This variable is independant of the logging levels

    static var debugMode = false
    
    
    /// This is the port number upon which new connection requests will be accepted

    static var httpServicePortNumber = "6678"
    

    /// This is the maximum number of (parralel) http connection requests that Swiftfire accepts. Any more than this will become pending.

    static var maxNofAcceptedConnections = 20
    
    
    /// This is the maximum number of http connection requests that are kept pending. Any more than this and will be rejected.

    static var maxNofPendingConnections: Int32 = 20
    
    
    /// This is the maximum time a pending connection request is kept waiting before it is rejected.

    static var maxWaitForPendingConnections = 30 // In seconds
    
    
    /// The maximum size of a http message that can be received from client.

    static var clientMessageBufferSize = 100_000 // In bytes
    
    
    /// When a HTTP request has the "keep alive" option set, the connection will remain open for this time after the last data block was processed from that client.

    static var httpKeepAliveInactivityTimeout = 1 // In seconds
    
    
    /// When data has to be transferred to a client, this is the timeout for the transmit operation.

    static var httpResponseClientTimeout = 10.0 // In seconds
    
    
    /// When the M&C connection has been established, it will remain locked to the given connection until no activity has been detected for this amount of time. Note that when a console periodically retrieves telemetry, that interval should be shorter than this inactvity timeout or else another console could take over. Time is in seconds.

    static var macInactivityTimeout = 600.0 // In seconds
    
    
    /// When set to true the http server will automatically be started upon start of the application. Note that domains should be defined and active for this to have any effect.

    static var autoStartup = true
    
    
    /// The port number on which Swiftfire will listen for M&C connections.

    static var macPortNumber = "2043"
    

    /// The ASL threshold, logging information at this level (or above) will be written to the ASL Facility

    static var aslFacilityRecordAtAndAboveLevel = SwifterLog.Level.notice
    
    
    /// The stdout threshold, logging information at this level (or above) will be written to stdout (terminal/xcode console)

    static var stdoutPrintAtAndAboveLevel = SwifterLog.Level.none
    
    
    /// The callback threshold, logging information at this level (or above) will be send to the Swiftfire Console

    static var callbackAtAndAboveLevel = SwifterLog.Level.none
    
    
    /// The file logging threshold, logging information at this level (or above) will be written to the logfile.

    static var fileRecordAtAndAboveLevel = SwifterLog.Level.none
    
    
    /// The maximum size of a single logfile (in kbytes)

    static var logfileMaxSize = 1000 // 1MB
    
    
    /// The maximum number of logfiles that will be kept in the logfile directory

    static var logfileMaxNofFiles = 20
    
    
    /// The network target threshold, logging information at this level (or above) will be sent to the network destination.

    static var networkTransmitAtAndAboveLevel = SwifterLog.Level.none
    
    
    /// The IP Address for the network logging target
    
    static var networkLogtargetIpAddress = ""
    
    
    /// The port number for the network logging target
    
    static var networkLogtargetPortNumber = ""
    
    
    /// Enables/Disables logging of all request headers

    static var headerLoggingEnabled = false
    
    
    /// The maximum file size for header logging (in kbytes)

    static var maxFileSizeForHeaderLogging = 1000 // 1MB
    
    
    /// Synchronize the header logging file after each write

    static var flushHeaderLogfileAfterEachWrite = false

    
    // No instantiations
    
    private init() {}
    
    
    /**
     Updates the parameter values from the parameter-defaults.json file if that file exists. It only updates those values that are found in the defaults file. All other parameters remain at their hard-coded default values. Parameters found in the defaults file that are not (no longer?) used will be flagged as errors in the log.
     */
    
    static func restore() {
                
        // Does the parameter defaults file exist?
        
        guard FileURLs.exists(url: FileURLs.parameterDefaults) else {
            log.atLevelNotice(id: -1, source: #file.source(#function, #line), message: "No 'parameter-defaults.json' file present, starting with hard coded defaults.")
            return
        }

        
        // Extract the JSON hierarchy from the parameter defaults file
        
        do {
            let json = try VJson.parse(file: FileURLs.parameterDefaults!)
            
            // Read the parameter values from the JSON hierarchy into a parameter dictionary object
            
            if let value = (json|DEBUG_MODE)?.boolValue { debugMode = value ; json.removeChildren(withName: DEBUG_MODE) }
            if let value = (json|SERVICE_PORT_NUMBER)?.stringValue { httpServicePortNumber = value ; json.removeChildren(withName: SERVICE_PORT_NUMBER) }
            if let value = (json|MAX_NOF_ACCEPTED_CONNECTIONS)?.intValue { maxNofAcceptedConnections = value ; json.removeChildren(withName: MAX_NOF_ACCEPTED_CONNECTIONS) }
            if let value = (json|MAX_NOF_PENDING_CONNECTIONS)?.int32Value { maxNofPendingConnections = value ; json.removeChildren(withName: MAX_NOF_PENDING_CONNECTIONS) }
            if let value = (json|MAX_WAIT_FOR_PENDING_CONNECTIONS)?.intValue { maxWaitForPendingConnections = value ; json.removeChildren(withName: MAX_WAIT_FOR_PENDING_CONNECTIONS)}
            if let value = (json|CLIENT_MESSAGE_BUFFER_SIZE)?.intValue { clientMessageBufferSize = value ; json.removeChildren(withName: CLIENT_MESSAGE_BUFFER_SIZE)}
            if let value = (json|HTTP_KEEP_ALIVE_INACTIVITY_TIMEOUT)?.intValue { httpKeepAliveInactivityTimeout = value ; json.removeChildren(withName: HTTP_KEEP_ALIVE_INACTIVITY_TIMEOUT)}
            if let value = (json|HTTP_RESPONSE_CLIENT_TIMEOUT)?.doubleValue { httpResponseClientTimeout = value ; json.removeChildren(withName: HTTP_RESPONSE_CLIENT_TIMEOUT)}
            if let value = (json|MAC_INACTIVITY_TIMEOUT)?.doubleValue { macInactivityTimeout = value ; json.removeChildren(withName: MAC_INACTIVITY_TIMEOUT)}
            if let value = (json|AUTO_STARTUP)?.boolValue { autoStartup = value ; json.removeChildren(withName: AUTO_STARTUP)}
            if let value = (json|MAC_PORT_NUMBER)?.stringValue { macPortNumber = value ; json.removeChildren(withName: MAC_PORT_NUMBER)}
            if let value = (json|ASL_FACILITY_RECORD_AT_AND_ABOVE_LEVEL)?.intValue, let level = SwifterLog.Level(rawValue: value) { aslFacilityRecordAtAndAboveLevel = level ; json.removeChildren(withName: ASL_FACILITY_RECORD_AT_AND_ABOVE_LEVEL)}
            if let value = (json|STDOUT_PRINT_AT_AND_ABOVE_LEVEL)?.intValue, let level = SwifterLog.Level(rawValue: value) { stdoutPrintAtAndAboveLevel = level ; json.removeChildren(withName: STDOUT_PRINT_AT_AND_ABOVE_LEVEL)}
            if let value = (json|CALLBACK_AT_AND_ABOVE_LEVEL)?.intValue, let level = SwifterLog.Level(rawValue: value) { callbackAtAndAboveLevel = level ; json.removeChildren(withName: CALLBACK_AT_AND_ABOVE_LEVEL)}
            if let value = (json|FILE_RECORD_AT_AND_ABOVE_LEVEL)?.intValue, let level = SwifterLog.Level(rawValue: value) { fileRecordAtAndAboveLevel = level ; json.removeChildren(withName: FILE_RECORD_AT_AND_ABOVE_LEVEL)}
            if let value = (json|LOGFILE_MAX_SIZE)?.intValue { logfileMaxSize = value ; json.removeChildren(withName: LOGFILE_MAX_SIZE)}
            if let value = (json|LOGFILE_MAX_NOF_FILES)?.intValue { logfileMaxNofFiles = value ; json.removeChildren(withName: LOGFILE_MAX_NOF_FILES)}
            if let value = (json|NETWORK_TRANSMIT_AT_AND_ABOVE_LEVEL)?.intValue, let level = SwifterLog.Level(rawValue: value) { networkTransmitAtAndAboveLevel = level ; json.removeChildren(withName: NETWORK_TRANSMIT_AT_AND_ABOVE_LEVEL)}
            if let value = (json|NETWORK_LOGTARGET_IP_ADDRESS)?.stringValue { networkLogtargetIpAddress = value ; json.removeChildren(withName: NETWORK_LOGTARGET_IP_ADDRESS) }
            if let value = (json|NETWORK_LOGTARGET_PORT_NUMBER)?.stringValue { networkLogtargetPortNumber = value ; json.removeChildren(withName: NETWORK_LOGTARGET_PORT_NUMBER) }
            if let value = (json|HEADER_LOGGING_ENABLED)?.boolValue { headerLoggingEnabled = value ; json.removeChildren(withName: HEADER_LOGGING_ENABLED) }
            if let value = (json|MAX_FILE_SIZE_FOR_HEADER_LOGGING)?.intValue { maxFileSizeForHeaderLogging = value ; json.removeChildren(withName: MAX_FILE_SIZE_FOR_HEADER_LOGGING) }
            if let value = (json|FLUSH_HEADER_LOGFILE_AFTER_EACH_WRITE)?.boolValue { flushHeaderLogfileAfterEachWrite = value ; json.removeChildren(withName: FLUSH_HEADER_LOGFILE_AFTER_EACH_WRITE) }
            
            
            // If the json object still contains children, log them as warnings
            
            for c in json {
                log.atLevelWarning(id: -1, source: "Parameters", message: "Id '\(c.nameValue)' in parameter default file was ignored (either a duplicate or not used)")
            }

        } catch let error {
        
            log.atLevelError(id: -1, source: #file.source(#function, #line), message: "Could not retrieve JSON code from parameter-defaults file. Error = \(error).")
        }
    }
    
    
    /**
     Save the parameter dictionary contents to the 'domains-default.json' file.
     */

    static func save() {
        
        if let file = FileURLs.parameterDefaults {
            
            let json = VJson()
        
            json[DEBUG_MODE] &= debugMode
            json[SERVICE_PORT_NUMBER] &= httpServicePortNumber
            json[MAX_NOF_ACCEPTED_CONNECTIONS] &= maxNofAcceptedConnections
            json[MAX_NOF_PENDING_CONNECTIONS] &= maxNofPendingConnections
            json[MAX_WAIT_FOR_PENDING_CONNECTIONS] &= maxWaitForPendingConnections
            json[CLIENT_MESSAGE_BUFFER_SIZE] &= clientMessageBufferSize
            json[HTTP_KEEP_ALIVE_INACTIVITY_TIMEOUT] &= httpKeepAliveInactivityTimeout
            json[HTTP_RESPONSE_CLIENT_TIMEOUT] &= httpResponseClientTimeout
            json[MAC_INACTIVITY_TIMEOUT] &= macInactivityTimeout
            json[AUTO_STARTUP] &= autoStartup
            json[MAC_PORT_NUMBER] &= macPortNumber
            json[ASL_FACILITY_RECORD_AT_AND_ABOVE_LEVEL] &= aslFacilityRecordAtAndAboveLevel.rawValue
            json[STDOUT_PRINT_AT_AND_ABOVE_LEVEL] &= stdoutPrintAtAndAboveLevel.rawValue
            json[CALLBACK_AT_AND_ABOVE_LEVEL] &= callbackAtAndAboveLevel.rawValue
            json[FILE_RECORD_AT_AND_ABOVE_LEVEL] &= fileRecordAtAndAboveLevel.rawValue
            json[LOGFILE_MAX_SIZE] &= logfileMaxSize
            json[LOGFILE_MAX_NOF_FILES] &= logfileMaxNofFiles
            json[NETWORK_TRANSMIT_AT_AND_ABOVE_LEVEL] &= networkTransmitAtAndAboveLevel.rawValue
            json[NETWORK_LOGTARGET_IP_ADDRESS] &= networkLogtargetIpAddress
            json[NETWORK_LOGTARGET_PORT_NUMBER] &= networkLogtargetPortNumber
            json[HEADER_LOGGING_ENABLED] &= headerLoggingEnabled
            json[MAX_FILE_SIZE_FOR_HEADER_LOGGING] &= maxFileSizeForHeaderLogging
            json[FLUSH_HEADER_LOGFILE_AFTER_EACH_WRITE] &= flushHeaderLogfileAfterEachWrite
            
            json.save(to: file)
        
        } else {
        
            log.atLevelError(id: -1, source: "Parameters", message: "Could not save parameters to file")
        }
    }
    
    
    static func logParameterSettings(atLevel level: SwifterLog.Level) {
        
        log.atLevel(level, id: -1, source: "Parameters", message: "\(DEBUG_MODE) = \(debugMode)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(SERVICE_PORT_NUMBER) = \(httpServicePortNumber)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(MAX_NOF_ACCEPTED_CONNECTIONS) = \(maxNofAcceptedConnections)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(MAX_NOF_PENDING_CONNECTIONS) = \(maxNofPendingConnections)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(MAX_WAIT_FOR_PENDING_CONNECTIONS) = \(maxWaitForPendingConnections)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(CLIENT_MESSAGE_BUFFER_SIZE) = \(clientMessageBufferSize)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(HTTP_KEEP_ALIVE_INACTIVITY_TIMEOUT) = \(httpKeepAliveInactivityTimeout)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(HTTP_RESPONSE_CLIENT_TIMEOUT) = \(httpResponseClientTimeout)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(MAC_INACTIVITY_TIMEOUT) = \(macInactivityTimeout)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(AUTO_STARTUP) = \(autoStartup)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(MAC_PORT_NUMBER) = \(macPortNumber)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(ASL_FACILITY_RECORD_AT_AND_ABOVE_LEVEL) = \(aslFacilityRecordAtAndAboveLevel.rawValue)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(STDOUT_PRINT_AT_AND_ABOVE_LEVEL) = \(stdoutPrintAtAndAboveLevel.rawValue)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(CALLBACK_AT_AND_ABOVE_LEVEL) = \(callbackAtAndAboveLevel.rawValue)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(FILE_RECORD_AT_AND_ABOVE_LEVEL) = \(fileRecordAtAndAboveLevel.rawValue)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(LOGFILE_MAX_SIZE) = \(logfileMaxSize)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(LOGFILE_MAX_NOF_FILES) = \(logfileMaxNofFiles)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(NETWORK_TRANSMIT_AT_AND_ABOVE_LEVEL) = \(networkTransmitAtAndAboveLevel.rawValue)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(NETWORK_LOGTARGET_IP_ADDRESS) = \(networkLogtargetIpAddress)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(NETWORK_LOGTARGET_PORT_NUMBER) = \(networkLogtargetPortNumber)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(HEADER_LOGGING_ENABLED) = \(headerLoggingEnabled)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(MAX_FILE_SIZE_FOR_HEADER_LOGGING) = \(maxFileSizeForHeaderLogging)")
        log.atLevel(level, id: -1, source: "Parameters", message: "\(FLUSH_HEADER_LOGFILE_AFTER_EACH_WRITE) = \(flushHeaderLogfileAfterEachWrite)")
    }
}

// == End of file ==
