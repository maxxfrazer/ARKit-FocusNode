//
//  ViewController+ARSCNViewDelegate.swift
//  FocusNode+Example
//
//  Created by Max Cobb on 12/23/18.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import ARKit

extension ViewController: ARSCNViewDelegate {
	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
		DispatchQueue.main.async {
			self.focusNode.updateFocusNode()
		}
	}
}
