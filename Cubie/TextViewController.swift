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

class TextViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Display Text",
                                   subtitle: "Displays 3D text",
                                   instance: TextViewController.self)
    
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
        
        let textGeomerty = SCNText(string: "Mubaloo", extrusionDepth: 1)
        textGeomerty.firstMaterial?.diffuse.contents = UIColor.blue
        
        let textNode = SCNNode(geometry: textGeomerty)
        textNode.position = SCNVector3(0, 0.1, -0.5)
        textNode.scale = SCNVector3(0.02, 0.02, 0.02)
        
        scene.rootNode.addChildNode(textNode)
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

