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

class MultipleObjectsViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Multiple Objects",
                                   subtitle: "Shows you how to display multiple SCNNodes on the view",
                                   instance: MultipleObjectsViewController.self)
    
    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = #imageLiteral(resourceName: "brick")
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.geometry?.materials = [material]
        boxNode.position = SCNVector3(0, 0.1, -0.5)
        
        let sphere = SCNSphere(radius: 0.2)
        
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = #imageLiteral(resourceName: "earth")
        
        let sphereNode = SCNNode()
        sphereNode.geometry = sphere
        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(0.5, 0.1, -1)
        
        scene.rootNode.addChildNode(boxNode)
        scene.rootNode.addChildNode(sphereNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
}


