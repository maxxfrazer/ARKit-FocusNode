//
//  float4x4+Extension.swift
//  FocusNode
//
//  Created by Max Cobb on 12/5/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import SceneKit

internal extension float4x4 {
	/**
	Treats matrix as a (right-hand column-major convention) transform matrix
	and factors out the translation component of the transform.
	*/
	var translation: float3 {
		get {
			let translation = columns.3
			return float3(translation.x, translation.y, translation.z)
		}
		set(newValue) {
			columns.3 = float4(newValue.x, newValue.y, newValue.z, columns.3.w)
		}
	}

	/**
	Factors out the orientation component of the transform.
	*/
	var orientation: simd_quatf {
		return simd_quaternion(self)
	}
}
