//
//  CubeViewController.swift
//  Cubie
//
//  Created by Jordan.Dixon on 10/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class OverlayingPlaneViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Overlay Planes",
                                   subtitle: "Overlay a virtual plane on a physical plane",
                                   instance: OverlayingPlaneViewController.self)
    
    var sceneView: ARSCNView!
    var planes = [OverlayPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.frame)
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]

        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self

        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        
        let plane = OverlayPlane(anchor: anchor)
        planes.append(plane)
        
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let plane = self.planes.filter { $0.anchor.identifier == anchor.identifier }.first
        
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        
        plane?.update(anchor: anchor)
    }
}

