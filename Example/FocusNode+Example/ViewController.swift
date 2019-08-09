//
//  ViewController.swift
//  FocusNode+Example
//
//  Created by Max Cobb on 12/23/18.
//  Copyright © 2018 Max Cobb. All rights reserved.
//

import ARKit
import FocusNode

extension ARSCNView: ARSmartHitTestSCN {}

class ViewController: UIViewController {

	var sceneView = ARSCNView(frame: .zero)
	let focusNode = FocusSquare()

	override func viewDidLoad() {
		super.viewDidLoad()

		sceneView.frame = self.view.bounds
		self.view.addSubview(sceneView)
		self.sceneView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

		sceneView.delegate = self
		sceneView.showsStatistics = true

		self.focusNode.viewDelegate = sceneView
		sceneView.scene.rootNode.addChildNode(self.focusNode)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let configuration = ARWorldTrackingConfiguration()

		configuration.planeDetection = [.horizontal, .vertical]

		sceneView.session.run(configuration)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		sceneView.session.pause()
	}
}
