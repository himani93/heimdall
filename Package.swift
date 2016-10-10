import PackageDescription

let package = Package(
    name: "VaporLogger",
    dependencies: [
	.Package(url: "https://github.com/vapor/engine.git", majorVersion: 1)
	]

)
