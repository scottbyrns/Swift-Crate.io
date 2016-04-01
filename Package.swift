import PackageDescription

let package = Package(
    name: "CrateIO",
    dependencies: [
        .Package(url: "https://github.com/VeniceX/TCP.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/JSON.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/Digest.git", majorVersion: 0, minor: 0),
        .Package(url: "https://github.com/Zewo/HTTP.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/Data.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/HTTPParser.git", majorVersion: 0, minor: 4),
        .Package(url: "https://github.com/Zewo/HTTPSerializer.git", majorVersion: 0, minor: 4)

    ]
)
