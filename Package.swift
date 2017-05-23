import PackageDescription

let package = Package(
    name: "Heimdall",
    dependencies: [
        .Package(url: "https://github.com/vapor/engine.git", majorVersion: 2),
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
	]

)
