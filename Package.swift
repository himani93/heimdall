import PackageDescription

let package = Package(
    name: "VaporLogger",
    dependencies: [
	.Package(url: "https://github.com/vapor/engine.git", majorVersion: 1),
	.Package(url: "https://github.com/vapor/vapor.git", majorVersion: 1)
	]

)
