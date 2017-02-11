import PackageDescription

let package = Package(
    name: "Swiftfire",
    dependencies: [
        .Package(url: "../SecureSockets", Version(0,  3,  3)),
        .Package(url: "../SwifterLog",    Version(0,  9, 18)),
        .Package(url: "../SwiftfireCore", Version(0,  1,  0))
    ]
)