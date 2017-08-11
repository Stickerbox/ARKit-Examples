//
//  TargetShooterViewController.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

enum BoxBodyType: Int {
    case bullet = 1
    case target = 2
}

enum BoxName: String {
    case bullet
    case targetOne
    case targetTwo
    case targetThree
}

class TargetShooterViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Target Shooter",
                                   subtitle: "Shoot red boxes with yellow boxes to make them turn green",
                                   instance: TargetShooterViewController.self)
    
    var sceneView: ARSCNView!
    var lastContactNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.frame)
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        addTargets(to: scene)

        scene.physicsWorld.contactDelegate = self
        
        // Set the scene to the view
        sceneView.scene = scene
        
        registerGestures()
    }
    
    private func addTargets(to scene: SCNScene) {
        
        var targets = [SCNNode]()
        targets.append(createTarget(at: SCNVector3(0, 0, -1.8), named: .targetOne))
        targets.append(createTarget(at: SCNVector3(0.2, -0.2, -2.4), named: .targetTwo))
        targets.append(createTarget(at: SCNVector3(0.5, 0.1, -5.0), named: .targetThree))
        
        targets.forEach { scene.rootNode.addChildNode($0) }
    }
    
    private func createTarget(at position: SCNVector3, named name: BoxName) -> SCNNode {
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        boxNode.position = position
        boxNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        boxNode.physicsBody?.contactTestBitMask = BoxBodyType.target.rawValue
        boxNode.name = name.rawValue
        
        return boxNode
    }
    
    private func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        guard let currentFrame = self.sceneView.session.currentFrame else { return }
        
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.3 // set it away from us
        
        let box = SCNBox(width: 0.05, height: 0.05, length: 0.1, chamferRadius: 0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.yellow
        box.materials = [material]
        
        let boxNode = SCNNode(geometry: box)
        boxNode.name = BoxName.bullet.rawValue
        
        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        boxNode.physicsBody?.isAffectedByGravity = false
        boxNode.physicsBody?.contactTestBitMask = BoxBodyType.bullet.rawValue
        boxNode.physicsBody?.contactTestBitMask = BoxBodyType.target.rawValue // this will trigger the didBegin delegate method
        
        // multiply the current frame matrix to push the box away
        boxNode.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        
        let forceVector = SCNVector3(boxNode.worldFront.x * 2, boxNode.worldFront.y * 2, boxNode.worldFront.z * 2)
        
        boxNode.physicsBody?.applyForce(forceVector, asImpulse: true)
        
        self.sceneView.scene.rootNode.addChildNode(boxNode)
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

extension TargetShooterViewController: SCNPhysicsContactDelegate {
    
    // this method will get called a lot
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        var contactNode: SCNNode
        
        if contact.nodeA.name == BoxName.bullet.rawValue {
            // we know nodeB will be a target
            contactNode = contact.nodeB
        } else {
            contactNode = contact.nodeA
        }
        
        // do this because the method gets called a bunch of times while two objects are touching
        if let lastNode = self.lastContactNode, lastNode == contactNode { return }
        
        self.lastContactNode = contactNode
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        
        self.lastContactNode?.geometry?.materials = [material]
        
    }
}

