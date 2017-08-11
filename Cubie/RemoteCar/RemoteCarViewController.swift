//
//  RemoteCarViewController.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RemoteCarViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Remote Controlled Car",
                                   subtitle: "Drive the worst car ever",
                                   instance: RemoteCarViewController.self)
    
    var sceneView: ARSCNView!
    var planes = [OverlayPlane]()
    
    private var car: Car!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: view.frame)
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
        let scene = SCNScene()
        
        let carScene = SCNScene(named: "art.scnassets/car.scn")
        if let carNode = carScene?.rootNode.childNode(withName: "car", recursively: true) {
            
            carNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            carNode.physicsBody?.categoryBitMask = BodyType.car.rawValue
            
            self.car = Car(node: carNode)
        }
        
        // Set the scene to the view
        sceneView.scene = scene
        
        registerGestures()
        
        setupControlPad()
    }
    
    private func setupControlPad() {
        
        let leftButton = GameButton(frame: CGRect(x: 0, y: sceneView.frame.height - 80, width: 50, height: 50)) {
            self.car.turnLeft()
        }
        leftButton.setTitle("◀︎", for: .normal)
        
        let rightButton = GameButton(frame: CGRect(x: 60, y: sceneView.frame.height - 80, width: 50, height: 50)) {
            self.car.turnRight()
        }
        rightButton.setTitle("▶︎", for: .normal)
        
        let acceleratorButton = GameButton(frame: CGRect(x: sceneView.frame.width - 75, y: sceneView.frame.height - 80, width: 50, height: 50)) {
            self.car.accelerate()
        }
        
        acceleratorButton.setTitle("▲", for: .normal)
        acceleratorButton.backgroundColor = .black
        acceleratorButton.layer.cornerRadius = 10
        acceleratorButton.layer.masksToBounds = true
        
        sceneView.addSubview(leftButton)
        sceneView.addSubview(rightButton)
        sceneView.addSubview(acceleratorButton)
    }
    
    private func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(tapGesture)
    }
    
    // Adding virtual object to a virtual plane
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        if let carNode = sceneView.scene.rootNode.childNode(withName: "Car", recursively: true) {
            move(node: carNode, to: recognizer.location(in: sceneView))
            return
        }
        
        guard let sceneView = recognizer.view as? ARSCNView else { return }
        let touchLocation = recognizer.location(in: sceneView)
        
        let hitTest = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        guard let hitResult = hitTest.first else { return }
        let worldTransform = hitResult.worldTransform.columns.3
        
        car.position = SCNVector3(worldTransform.x, worldTransform.y, worldTransform.z)
        sceneView.scene.rootNode.addChildNode(car.carNode)
    }
    
    private func move(node: SCNNode, to point: CGPoint) {
        
        let results = sceneView.hitTest(point, types: [.featurePoint])
        
        guard let hitFeature = results.last else { return }
        
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        
        let hitPosition = SCNVector3Make(hitTransform.m41,
                                         hitTransform.m42,
                                         hitTransform.m43)
        node.position = hitPosition
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
        
        let plane = OverlayPlane(anchor: anchor, material: #imageLiteral(resourceName: "road"))
        planes.append(plane)
        
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        let plane = self.planes.filter { $0.anchor.identifier == anchor.identifier }.first
        
        guard let anchor = anchor as? ARPlaneAnchor else { return }
        
        plane?.update(anchor: anchor)
    }
}
