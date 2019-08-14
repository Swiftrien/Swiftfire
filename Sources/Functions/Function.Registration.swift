// =====================================================================================================================
//
//  File:       Functions.Registration.swift
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

import Core


// =================================
// Names for the available functions
// =================================


/// Example: .nofPageHits() will have the name "nofPageHits"

let TIMESTAMP = "timestamp"
let POSTING_LINK = "postingLink"
let POSTING_BUTTON = "postingButton"
let POSTING_BUTTONED_INPUT = "postingButtonedInput"
let NOF_PAGE_HITS = "nofPageHits"


// ==================================================
// Add to the next function to register new functions
// ==================================================
// The sequence is not important

/// Register the functions

public func registerFunctions() {
    functions.register(name: TIMESTAMP, function: function_timestamp)
    functions.register(name: POSTING_LINK, function: function_postingLink)
    functions.register(name: POSTING_BUTTON, function: function_postingButton)
    functions.register(name: POSTING_BUTTONED_INPUT, function: function_postingButtonedInput)
    functions.register(name: NOF_PAGE_HITS, function: function_nofPageHits)
}
