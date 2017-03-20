# Swiftfire
The next generation personal webserver written in Swift.

Visit the Swiftfire homepage at [http://swiftfire.nl](http://swiftfire.nl).

# Note

This is an early public release and I do not consider this code ready for prime time. It is experimental in nature and subject to severe rewrites as development continues.

However: It does work! :-)

# Features

- Webserver for static websites
- Handles multiple domains
- Client forwarding (to other hosts or a different port on the same host)
- Integrated usage statistics (page visits)
- Blacklisting (refusal of service) on IP basis for Server and per domain
- Supports HTTP1.0 and HTTP1.1
- Custom pages for errors (for example the infamous 404 page not found)
- Logging of received headers possible
- Logging of missing pages (404)
- Console application available
- Easy to extend for new domain services

# Installation
Please refer to the [installation instructions](http://swiftfire.nl/pages/manual/02_installation.html) on the [Swiftfire](http://swiftfire.nl) website.

# Version history

Note: Planned releases are for information only and almost always change.

#### 2.0.0 (Thought about)

- Adding support for dynamic content
- Session support
- Add URL redirection list

#### 1.0.0 (Planned)

- 1-3 months after v0.10.0
- Bugfixes
- Small feature improvements (if necessary)
- Code improvements

#### 0.10.0 (Planned)

- HTTPS support

#### 0.9.17 (Current)

- Use SSL for the interface to SwiftfireConsole

#### 0.9.16

- Infrastructure update (no code changes).

#### 0.9.15

- Switched to SwiftPM distribution
- Updated for new approach in SwifterSockets

#### 0.9.14

- Added IP Address block list (blacklists)
- Added custom error pages (for example the 404 error) support
- Upgrade to Xcode 8 beta 6 (Swift 3)
- Major improvements of the GUI console

#### 0.9.13

- Updated for Xcode 8 beta 3 (Swift 3)

#### 0.9.12

- Added usage charts that track the number of page visits over time
- Added enabling/disabling of visit counting for specific resources

#### 0.9.11

- Merged SwiftfireConsole into this project as an extra target
- Added usage statistics for client & domain usage.
- Updated for VJson 0.9.8

#### 0.9.10

- Added domain statistics

#### 0.9.9

- Fixed a bug in SwifterSockets that would not log correct IPv6 addresses.
- Fixed a number of bugs that messed up logging of access and 404
- Renamed FileLog to Logfile
- Replaced header logging code with usage of Logfile

#### 0.9.8

- Quick fix for bug that would prevent creation of AccessLog and Four04Log.

#### 0.9.7

- Cleaned up parameter definition setting and usage
- Added option to log all HTTP request headers
- Added option to log all access to a domain
- Added option to log all URLs that result in a 404 reply
- Few minor bug fixes (minor = will probably never occur and does not impact functionaly)

#### 0.9.6

- Header update to include new website: [swiftfire.nl](http://swiftfire.nl)
- Removed Startup, folded into Parameters
- Merged MAX_NOF_PENDING_CLIENT_MESSAGES with MAX_CLIENT_MESSAGE_SIZE into CLIENT_MESSAGE_BUFFER_SIZE
- Save & Restore no longer preserve telemetry values
- Added transmission of "ClosingMacConnection" info upon timeout for the M&C connection
- Added ResetDomainTelemetry command

#### 0.9.5

- Fixed bug that prevented domain creation
- Added MIME type support based on the file extension

#### 0.9.4

- Switched to VJSON pipe operators
- Simplified the SwifterConsole M&C interface

#### 0.9.3

- Added domain telemetry

#### 0.9.2

- Minor changes to accomodate changes in other packages

#### 0.9.1

- Minor changes to accomodate changes in SwifterSockets/SwifterLog/SwifterJSON
- Added 'descriptionWithSeparator' to Extensions.swift
- Added release tags

#### 0.9.0

- Initial public release
