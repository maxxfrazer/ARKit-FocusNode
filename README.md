# FocusNode

The root class here uses a class I found in Apple's documentation for ARKit apps that I wanted to have easy to use myself, and thought others would benefit from it too.

[![Actions Status](https://github.com/maxxfrazer/ARKit-FocusNode/workflows/build/badge.svg)](https://github.com/maxxfrazer/ARKit-FocusNode/actions)
[![Version](https://img.shields.io/cocoapods/v/FocusNode.svg)](https://cocoapods.org/pods/FocusNode)
[![License](https://img.shields.io/cocoapods/l/FocusNode.svg)](https://cocoapods.org/pods/FocusNode)
[![Platform](https://img.shields.io/cocoapods/p/FocusNode.svg)](https://cocoapods.org/pods/FocusNode)
[![Swift Package Manager](https://img.shields.io/badge/SwiftPM_📦-v2.0.2-orange.svg?style=flat)](https://github.com/apple/swift-package-manager)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)

![FocusNode Example 1](https://github.com/maxxfrazer/ARKit-FocusNode/blob/master/media/FocusNode-Example1.gif)

[The Example](./Example) looks identical to the above GIF.

[Medium Article V1 of this CocoaPod](https://medium.com/@maxxfrazer/arkit-pods-focusnode-46343cffe7fe)


It was found inside the downloadable project on the following page:
https://developer.apple.com/documentation/arkit/handling_3d_interaction_and_ui_controls_in_augmented_reality

I've added the license from that project to this repository.

For a similar object to place into a RealityKit scene, try the [FocusEntity Repository](https://github.com/maxxfrazer/FocusEntity).

## Minimum Requirements
  - Swift 5.0
  - iOS 11.3

## Installation

### Swift Package Manager

Add the URL of this repository to your Xcode 11+ Project and select version 2.0+
`https://github.com/maxxfrazer/ARKit-FocusNode.git`

### CocoaPods
Include this pod in your Podfile like so:

```ruby
pod 'FocusNode'
```
---
## Usage

See the [Example](./Example) for a full working example as can be seen in the image above

### V2

Follow steps in [V1](v1), and then whatever you have as your `sceneView` class, for example `ARSCNView`, add the protocol of `ARSmartHitTest` to it like the following:
```swift
extension ARSCNView: ARSmartHitTest {}
```

### V1
Import `FocusNode` to your .swift file and add it to your scene as so:

```swift
let focusNode = FocusSquare()
sceneView.scene.rootNode.addChildNode(self.focusNode)
focusNode.viewDelegate = sceneView
```

Check out the Example project or message me on GitHub or twitter if it's unclear.


I DID NOT WRITE A MAJORITY OF THIS CODE MYSELF, MOST OF IT WAS TAKEN DIRECTLY FROM APPLE'S EXAMPLES
