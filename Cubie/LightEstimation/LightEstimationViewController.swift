//
//  LightEstimationViewController.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class LightEstimationViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Light Estimation",
                                   subtitle: "Estimates the light based on the ambient light",
                                   instance: LightEstimationViewController.self)
    
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
        
        registerGestures()
        addSpotlight(at: SCNVector3(0, 1.0, 0))
    }
    
    private func addSpotlight(at position: SCNVector3) {
        
        let spotlight = SCNLight()
        spotlight.type = .spot
        spotlight.spotInnerAngle = 45
        spotlight.spotOuterAngle = 45
        
        let spotlightNode = SCNNode()
        spotlightNode.name = "SpotNode"
        spotlightNode.light = spotlight
        spotlightNode.position = position
        
        spotlightNode.eulerAngles = SCNVector3(-Double.pi / 2.0, 0, -0.2)
        
        sceneView.scene.rootNode.addChildNode(spotlightNode)
    }
    
    private func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGesture)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        
        tapGesture.require(toFail: doubleTap)
        
        sceneView.addGestureRecognizer(doubleTap)
    }
    
    // Adding virtual object to a virtual plane
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else { return }
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        guard let hitResult = hitTest.first else { return }
        
        addBox(hitResult: hitResult)
    }
    
    // Applying force to a virtual object
    @objc func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else { return }
        let touch = recognizer.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(touch, options: [:])
        
        guard let hitResult = hitTest.first else { return }
        
        let node = hitResult.node
        node.physicsBody?.applyForce(SCNVector3(hitResult.worldCoordinates.x * 10,
                                                2.0,
                                                hitResult.worldCoordinates.z * 10),
                                     asImpulse: true)
    }
    
    private func addBox(hitResult: ARHitTestResult) {
        
        let boxGeomertry = SCNBox(width: 0.2, height: 0.2, length: 0.1, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        boxGeomertry.materials = [material]
        
        let boxNode = SCNNode(geometry: boxGeomertry)
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.categoryBitMask = BodyType.box.rawValue
        
        let worldTransform = hitResult.worldTransform.columns.3
        
        boxNode.position = SCNVector3(worldTransform.x,
                                      worldTransform.y + Float(0.5),
                                      worldTransform.z)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
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
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        
        guard let lightEstimate = sceneView.session.currentFrame?.lightEstimate else { return }
        
        guard let spotlightNode = sceneView.scene.rootNode.childNode(withName: "SpotNode", recursively: true) else { return }
        
        spotlightNode.light?.intensity = lightEstimate.ambientIntensity
    }
}

