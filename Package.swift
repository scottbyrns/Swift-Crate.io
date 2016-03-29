import PackageDescription

let package = Package(
    name: "CrateIO",
    dependencies: [
        .Package(url: "https://github.com/scottbyrns/Socks.git", majorVersion: 0, minor: 0),
        .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: 4)
    ]
)
