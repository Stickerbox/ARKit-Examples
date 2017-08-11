//
//  MissileLaunchViewController.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MissileLaunchViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Missile Launcher",
                                   subtitle: "Just like North Korea, this rocket will either launch or just combust",
                                   instance: MissileLaunchViewController.self)
    
    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(self.sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        guard let missileScene = SCNScene(named: "art.scnassets/missile.scn") else { return }
        
        let missile = Missile(scene: missileScene)
        missile.name = "Missile"
        missile.position = SCNVector3(0, 0, -4)
        
        let scene = SCNScene()
        scene.rootNode.addChildNode(missile)
        
        // Set the scene to the view
        sceneView.scene = scene
        
        registerGestures()
    }
    
    private func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        guard let missileNode = self.sceneView.scene.rootNode.childNode(withName: "Missile", recursively: true) as? Missile else { return }
        
        missileNode.launch(missileNode: missileNode)
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
}

