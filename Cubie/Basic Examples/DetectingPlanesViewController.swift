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

class DetectingPlaneViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Detecting Planes",
                                   subtitle: "Shows you how to detect planes",
                                   instance: DetectingPlaneViewController.self)
    
    var sceneView: ARSCNView!
    
    private var label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.frame)
        sceneView.debugOptions = [.showWireframe, .showLightInfluences]
        
        label.text = "Plane Detected"
        label.frame = CGRect(x: 0, y: 0, width: sceneView.frame.size.width, height: 44)
        label.center = sceneView.center
        label.textAlignment = .center
        label.textColor = .black

        self.view.addSubview(label)
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.4)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        let node = SCNNode()
        node.geometry = box
        node.geometry?.materials = [material]
        node.position = SCNVector3(0, 0.1, -0.5)
        
        scene.rootNode.addChildNode(node)
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
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 3.0, animations: {
                self.label.alpha = 1.0
            }) { _ in
                self.label.alpha = 0.0
            }
        }
        
    }
}

