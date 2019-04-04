//
//  FocusSquare.swift
//  FocusNode
//
//  Created by Max Cobb on 12/5/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import ARKit

/// This example class is taken almost entirely from Apple's own examples.
/// I have simply moved some things around to keep only what's necessary
///
/// An `SCNNode` which is used to provide uses with visual cues about the status of ARKit world tracking.
/// - Tag: FocusSquare
public class FocusSquare: FocusNode {

	// MARK: - Types
	public enum State: Equatable {
		case initializing
		case detecting(hitTestResult: ARHitTestResult, camera: ARCamera?)
	}

	// MARK: - Configuration Properties

	/// Original size of the focus square in meters.
	static let size: Float = 0.17

	/// Thickness of the focus square lines in meters.
	static let thickness: Float = 0.018

	/// Scale factor for the focus square when it is closed, w.r.t. the original size.
	static let scaleForClosedSquare: Float = 0.97

	/// Side length of the focus square segments when it is open (w.r.t. to a 1x1 square).
	static let sideLengthForOpenSegments: CGFloat = 0.2

	/// Duration of the open/close animation
	static let animationDuration = 0.7

	static var primaryColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)

	/// Color of the focus square fill.
	static var fillColor = #colorLiteral(red: 1, green: 0.9254901961, blue: 0.4117647059, alpha: 1)

	/// Indicates whether the segments of the focus square are disconnected.
	private var isOpen = true

	/// List of the segments in the focus square.
	private var segments: [FocusSquare.Segment] = []

	// MARK: - Initialization

	public override init() {
		super.init()
		opacity = 0.0

		/*
		The focus square consists of eight segments as follows, which can be individually animated.

		s1  s2
		_   _
		s3 |     | s4

		s5 |     | s6
		-   -
		s7  s8
		*/
		let s1 = Segment(name: "s1", corner: .topLeft, alignment: .horizontal)
		let s2 = Segment(name: "s2", corner: .topRight, alignment: .horizontal)
		let s3 = Segment(name: "s3", corner: .topLeft, alignment: .vertical)
		let s4 = Segment(name: "s4", corner: .topRight, alignment: .vertical)
		let s5 = Segment(name: "s5", corner: .bottomLeft, alignment: .vertical)
		let s6 = Segment(name: "s6", corner: .bottomRight, alignment: .vertical)
		let s7 = Segment(name: "s7", corner: .bottomLeft, alignment: .horizontal)
		let s8 = Segment(name: "s8", corner: .bottomRight, alignment: .horizontal)
		segments = [s1, s2, s3, s4, s5, s6, s7, s8]

		let sl: Float = 0.5  // segment length
		let c: Float = FocusSquare.thickness / 2 // correction to align lines perfectly
		s1.simdPosition += float3(-(sl / 2 - c), -(sl - c), 0)
		s2.simdPosition += float3(sl / 2 - c, -(sl - c), 0)
		s3.simdPosition += float3(-sl, -sl / 2, 0)
		s4.simdPosition += float3(sl, -sl / 2, 0)
		s5.simdPosition += float3(-sl, sl / 2, 0)
		s6.simdPosition += float3(sl, sl / 2, 0)
		s7.simdPosition += float3(-(sl / 2 - c), sl - c, 0)
		s8.simdPosition += float3(sl / 2 - c, sl - c, 0)

		for segment in segments {
			self.positioningNode.addChildNode(segment)
			segment.open()
		}
		self.positioningNode.addChildNode(fillPlane)
		self.positioningNode.simdScale = float3(repeating: FocusSquare.size * FocusSquare.scaleForClosedSquare)

		// Always render focus square on top of other content.
		self.displayNodeHierarchyOnTop(true)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("\(#function) has not been implemented")
	}

	// MARK: Animations

	override public func stateChanged(newPlane: Bool) {
		if self.onPlane {
			self.onPlaneAnimation(newPlane: newPlane)
		} else {
			self.offPlaneAniation()
		}
	}

	public func offPlaneAniation() {
		// Open animation
		guard !isOpen else {
			isAnimating = false
			return
		}
		isOpen = true
		SCNTransaction.begin()
		SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		SCNTransaction.animationDuration = FocusSquare.animationDuration / 4
		positioningNode.opacity = 1.0
		for segment in segments {
			segment.open()
		}
		SCNTransaction.completionBlock = {
			self.positioningNode.runAction(pulseAction(), forKey: "pulse")
			// This is a safe operation because `SCNTransaction`'s completion block is called back on the main thread.
			self.isAnimating = false
		}
		SCNTransaction.commit()
		// Add a scale/bounce animation.
		SCNTransaction.begin()
		SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		SCNTransaction.animationDuration = FocusSquare.animationDuration / 4
		positioningNode.simdScale = float3(repeating: FocusSquare.size)
		SCNTransaction.commit()
	}

	public func onPlaneAnimation(newPlane: Bool = false) {
		guard isOpen else {
			isAnimating = false
			return
		}
		isOpen = false
		positioningNode.removeAction(forKey: "pulse")
		positioningNode.opacity = 1.0

		// Close animation
		SCNTransaction.begin()
		SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		SCNTransaction.animationDuration = FocusSquare.animationDuration / 2
		positioningNode.opacity = 0.99
		SCNTransaction.completionBlock = {
			SCNTransaction.begin()
			SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
			SCNTransaction.animationDuration = FocusSquare.animationDuration / 4
			for segment in self.segments {
				segment.close()
			}
			SCNTransaction.completionBlock = {
				self.isAnimating = false
			}
			SCNTransaction.commit()
		}
		SCNTransaction.commit()

		// Scale/bounce animation
		positioningNode.addAnimation(scaleAnimation(for: "transform.scale.x"), forKey: "transform.scale.x")
		positioningNode.addAnimation(scaleAnimation(for: "transform.scale.y"), forKey: "transform.scale.y")
		positioningNode.addAnimation(scaleAnimation(for: "transform.scale.z"), forKey: "transform.scale.z")

		if newPlane {
			let waitAction = SCNAction.wait(duration: FocusSquare.animationDuration * 0.75)
			let fadeInAction = SCNAction.fadeOpacity(to: 0.25, duration: FocusSquare.animationDuration * 0.125)
			let fadeOutAction = SCNAction.fadeOpacity(to: 0.0, duration: FocusSquare.animationDuration * 0.125)
			fillPlane.runAction(SCNAction.sequence([waitAction, fadeInAction, fadeOutAction]))

			let flashSquareAction = flashAnimation(duration: FocusSquare.animationDuration * 0.25)
			for segment in segments {
				segment.runAction(.sequence([waitAction, flashSquareAction]))
			}
		}
	}

	// MARK: Convenience Methods

	private func scaleAnimation(for keyPath: String) -> CAKeyframeAnimation {
		let scaleAnimation = CAKeyframeAnimation(keyPath: keyPath)

		let easeOut = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
		let easeInOut = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		let linear = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)

		let size = FocusSquare.size
		let ts = FocusSquare.size * FocusSquare.scaleForClosedSquare
		let values = [size, size * 1.15, size * 1.15, ts * 0.97, ts]
		let keyTimes: [NSNumber] = [0.00, 0.25, 0.50, 0.75, 1.00]
		let timingFunctions = [easeOut, linear, easeOut, easeInOut]

		scaleAnimation.values = values
		scaleAnimation.keyTimes = keyTimes
		scaleAnimation.timingFunctions = timingFunctions
		scaleAnimation.duration = FocusSquare.animationDuration

		return scaleAnimation
	}

	private lazy var fillPlane: SCNNode = {
		let correctionFactor = FocusSquare.thickness / 2 // correction to align lines perfectly
		let length = CGFloat(1.0 - FocusSquare.thickness * 2 + correctionFactor)

		let plane = SCNPlane(width: length, height: length)
		let node = SCNNode(geometry: plane)
		node.name = "fillPlane"
		node.opacity = 0.0

		let material = plane.firstMaterial!
		material.diffuse.contents = FocusSquare.fillColor
		material.isDoubleSided = true
		material.ambient.contents = UIColor.black
		material.lightingModel = .constant
		material.emission.contents = FocusSquare.fillColor

		return node
	}()
}

// MARK: - Animations and Actions

private func pulseAction() -> SCNAction {
	let pulseOutAction = SCNAction.fadeOpacity(to: 0.4, duration: 0.5)
	let pulseInAction = SCNAction.fadeOpacity(to: 1.0, duration: 0.5)
	pulseOutAction.timingMode = .easeInEaseOut
	pulseInAction.timingMode = .easeInEaseOut

	return SCNAction.repeatForever(SCNAction.sequence([pulseOutAction, pulseInAction]))
}

private func flashAnimation(duration: TimeInterval) -> SCNAction {
	let action = SCNAction.customAction(duration: duration) { (node, elapsedTime) -> Void in
		// animate color from HSB 48/100/100 to 48/30/100 and back
		let elapsedTimePercentage = elapsedTime / CGFloat(duration)
		let saturation = 2.8 * (elapsedTimePercentage - 0.5) * (elapsedTimePercentage - 0.5) + 0.3
		if let material = node.geometry?.firstMaterial {
			material.diffuse.contents = UIColor(hue: 0.1333, saturation: saturation, brightness: 1.0, alpha: 1.0)
		}
	}
	return action
}
