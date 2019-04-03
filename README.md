# FocusNode

The root class here uses a class I found in Apple's documentation for ARKit apps that I wanted to have easy to use myself, and thought others would benefit from it too.

[![Version](https://img.shields.io/cocoapods/v/FocusNode.svg)](https://cocoapods.org/pods/FocusNode)
[![License](https://img.shields.io/cocoapods/l/FocusNode.svg)](https://cocoapods.org/pods/FocusNode)
[![Platform](https://img.shields.io/cocoapods/p/FocusNode.svg)](https://cocoapods.org/pods/FocusNode)
[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)
[![Build Status](https://travis-ci.com/maxxfrazer/ARKit-FocusNode.svg?branch=master)](https://travis-ci.com/maxxfrazer/ARKit-FocusNode)


It was found inside the downloadable project on the following page:
https://developer.apple.com/documentation/arkit/handling_3d_interaction_and_ui_controls_in_augmented_reality

I've added the license from that project to this repository.

I DID NOT WRITE A MAJORITY OF THIS CODE MYSELF, MOST OF IT WAS TAKEN DIRECTLY FROM APPLE'S EXAMPLES

Include this pod in your Podfile like so:

```
pod 'FocusNode'
```

Then import `FocusNode` to your .swift file and add it to your scene as so:

```
let focusNode = FocusSquare()
sceneView.scene.rootNode.addChildNode(self.focusNode)
focusNode.viewDelegate = sceneView
```

Check out the Example project or message me on GitHub or twitter if it's unclear.


The Example project looks like this:
