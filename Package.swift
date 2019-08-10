// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "FocusNode",
  platforms: [.iOS("11.3")],
  products: [
    .library(name: "FocusNode", targets: ["FocusNode"]),
  ],
  dependencies: [
//  .package(path: "../ARKit-SmartHitTest")
    .package(
      url: "https://github.com/maxxfrazer/ARKit-SmartHitTest",
      .upToNextMajor(from: "2.0.0")
    )
  ],
  targets: [
    .target(name: "FocusNode", dependencies: ["SmartHitTest"])
  ],
  swiftLanguageVersions: [.v5]
)
