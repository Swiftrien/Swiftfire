// =====================================================================================================================
//
//  File:       Function.SF.Blacklist.swift
//  Project:    Swiftfire
//
//  Version:    1.3.0
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
// 1.3.0 - Removed inout from the function.environment signature
// 1.2.1 - Removed dependency on Html
// 1.1.0 - Changed server blacklist location
// 1.0.0 - Raised to v1.0.0, Removed old change log,
//
// =====================================================================================================================
// Description
// =====================================================================================================================
//
// Returns a table with all blacklisted addresses.
//
//
// Signature:
// ----------
//
// .sf-blacklistTable()
//
//
// Parameters:
// -----------
//
// None.
//
//
// Other Input:
// ------------
//
// session = environment.serviceInfo[.sessionKey] // Must be a non-expired session.
// session[.accountKey] must contain an admin account
//
//
// Returns:
// --------
//
// The table with all blacklisted addresses or:
// - "Session error"
// - "Account error"
// - "Illegal access"
//
//
// Other Output:
// -------------
//
// None.
//
//
// =====================================================================================================================

import Foundation
import Core


/// Returns the value of the requested parameter item.
///
/// - Returns: The value of the requested parameter or "No access rights".

func function_sf_blacklistTable(_ args: Functions.Arguments, _ info: inout Functions.Info, _ environment: Functions.Environment) -> Data? {
    
    
    // Check access rights
    
    guard let session = environment.serviceInfo[.sessionKey] as? Session else {
        return "Session error".data(using: String.Encoding.utf8)
    }
    
    guard let account = session.info[.accountKey] as? Account else {
        return "Account error".data(using: String.Encoding.utf8)
    }
    
    guard serverAdminDomain.accounts.contains(account.uuid) else {
        return "Illegal access".data(using: String.Encoding.utf8)
    }
    
    
    // Create the table
    
    var html: String = """
        <table class="server-blacklist-table">
            <thead>
                <tr>
                    <th>Address</th>
                    <th>Action</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
    """
    
    let list = serverAdminDomain.blacklist.list.keys.sorted(by: { $0 < $1 })
    
    list.forEach { address in
        
        let action = serverAdminDomain.blacklist.action(for: address)
        
        html += """
            <tr>
                <td>\(address)</td>
                <td>
                    <form method="post" action="/serveradmin/sfcommand/UpdateBlacklist">
                        <input type="hidden" name="Address" value="\(address)">
                        <input type="radio" name="Action" value="close" \(action == .closeConnection ? "checked" : "")>
                        <span> Close Connection, </span>
                        <input type="radio" name="Action" value="503" \(action == .send503ServiceUnavailable ? "checked" : "")>
                        <span> 503 Service Unavailable, </span>
                        <input type="radio" name="Action" value="401" \(action == .send401Unauthorized ? "checked" : "")>
                        <span> 401 Unauthorized </span>
                        <input type="submit" value="Update">
                    </form>
                </td>
                <td>
                    <form method="post" action="/serveradmin/sfcommand/RemoveFromBlacklist">
                        <input type="hidden" name="Address" value="\(address)">
                        <input type="submit" value="Delete">
                    </form>
                </td>
            </tr>
        """
    }
    
    html += """
            </tbody>
        </table>
        <br>
        <form class="server-blacklist-create" method="post" action="/serveradmin/sfcommand/AddToBlacklist">
            <div>
                <span>Address: </span>
                <input type="text" name="NewEntry" value="">
            </div>
            <div>
                <input type="radio" name="Action" value="close" checked>
                <span> Close, </span>
                <input type="radio" name="Action" value="503">
                <span> 503 Service Unavailable, </span>
                <input type="radio" name="Action" value="401">
                <span> 401 Unauthorized</span>
            </div>
            <div>
                <input type="submit" value="Add to Blacklist">
            </div>
        </form>
    """
    
    return html.data(using: .utf8)
}

