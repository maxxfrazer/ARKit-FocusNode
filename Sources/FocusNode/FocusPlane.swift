//
//  FocusPlane.swift
//  FocusNode
//
//  Created by Max Cobb on 12/5/18.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import ARKit
import QuartzCore

/// A simple example subclass of FocusNode which shows whether the plane is
/// tracking on a known surface or estimating.
public class FocusPlane: FocusNode {

	/// Original size of the focus square in meters.
	let size: Float

	/// Color of the focus square fill when estimating position.
	static let offColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 0.5)
	/// Color of the focus square fill when at known position.
	static let onColor = #colorLiteral(red: 0, green: 1, blue: 0, alpha: 0.5)

	/// Set up the focus square with just the size as a parameter
	///
	/// - Parameter size: Size in m of the square. Default is 0.17
	public init(size: Float = 0.17) {
		self.size = size
		super.init()
		opacity = 0.0
		self.positioningNode.addChildNode(fillPlane)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("\(#function) has not been implemented")
	}

	// MARK: Animations

	/// Called when either `onPlane`, `state` or both have changed.
	///
	/// - Parameter newPlane: If the cube is tracking a new surface for the first time
	override public func stateChanged(newPlane: Bool) {
		if self.onPlane {
			positioningNode.removeAction(forKey: "pulse")
			self.fillPlane.geometry?.firstMaterial?.diffuse.contents = FocusPlane.onColor
			self.fillPlane.geometry?.firstMaterial?.emission.contents = FocusPlane.onColor
		} else {
			// Open animation
			self.fillPlane.geometry?.firstMaterial?.diffuse.contents = FocusPlane.offColor
			self.fillPlane.geometry?.firstMaterial?.emission.contents = FocusPlane.offColor
		}
		isAnimating = false
	}

	// MARK: Convenience Methods

	private lazy var fillPlane: SCNNode = {
		let correctionFactor = FocusSquare.thickness / 2 // correction to align lines perfectly
		let length = CGFloat(1.0 - FocusSquare.thickness * 2 + correctionFactor)

		let plane = SCNPlane(width: length, height: length)
		let node = SCNNode(geometry: plane)
		node.simdScale = SIMD3<Float>(repeating: self.size)
		node.name = "fillPlane"
		node.opacity = 0.5

		let material = plane.firstMaterial!
		material.diffuse.contents = FocusPlane.offColor
		material.isDoubleSided = true
		material.ambient.contents = UIColor.black
		material.lightingModel = .constant
		material.emission.contents = FocusPlane.offColor

		return node
	}()
}
