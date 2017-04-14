// =====================================================================================================================
//
//  File:       Service.GetOrStartSession.swift
//  Project:    Swiftfire
//
//  Version:    0.10.6
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
// 0.10.6 - Initial release
//
// =====================================================================================================================
// Description
// =====================================================================================================================
//
// Retrieves the session ID from the HTTP request if it has any. If no session ID is available a new session ID is
// created. It also writes the session ID to the HTTP response.
//
// As a side effect, all cookies will be read from the request. And when the response is created it will contain a
// set-cookie with the session ID. The timeout value will be set to Parameter.CookieTimeout.
//
//
// Input:
// ------
//
// request: The HTTP request.
//
//
// Output:
// -------
//
// info[sessionKey] = Existing session or new session.
// response: Will contain a cookie with the session ID and a timeout.
//
//
// Return:
// -------
//
// .next
//
// =====================================================================================================================

import Foundation
import SwifterLog
import SwiftfireCore
import SwifterSockets


/// Checks if the client IP address is in the domain.blacklist.
///
/// - Note: For a full description of all effects of this operation see the file: DomainService.GetFileAtResourcePath.swift
///
/// - Parameters:
///   - request: The HTTP request.
///   - connection: The HttpConnection object that is used for this connection.
///   - domain: The domain that is serviced for this request.
///   - info: A dictionary for communication between services.
///   - response: An object that can receive information to be returned in response to the request.
///
/// - Returns: On error .abort, on success .next.

func ds_getOrStartSession(_ request: HttpRequest, _ connection: Connection, _ domain: Domain, _ info: inout Service.Info, _ response: inout HttpResponse) -> Service.Result {

    
    // This will become the active session.
    
    var session: Session!

    
    // Find all session cookies (there should be only 1)
    
    let sessionCookies = request.cookies.filter({ $0.name == Session.cookieId })
    
    
    // If there is more than 1, pick the first active cookie.
    
    for sessionCookie in sessionCookies {
        if let id = UUID(uuidString: sessionCookie.value) {
            if let s = Session.activeSession(for: id) {
                session = s
            }
        }
    }
    
    
    // If no active session was found, create a new session
    
    if session == nil {
        session = Session.newSession(for: connection.remoteAddress)
    }
    
    
    // Store the session in the info object
    
    info[sessionKey] = session
    
    
    // Add the cookie to the response
    
    let timeout = HttpCookie.Timeout.maxAge(parameters.sessionTimeout)
    response.cookies?.append(HttpCookie(name: Session.cookieId, value: session.id, timeout: timeout))
    
    return .next
}
