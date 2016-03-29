import PackageDescription

let package = Package(
    name: "CrateIO",
    dependencies: [
        .Package(url: "https://github.com/scottbyrns/Socks.git", majorVersion: 0, minor: 0),
    ]
)
