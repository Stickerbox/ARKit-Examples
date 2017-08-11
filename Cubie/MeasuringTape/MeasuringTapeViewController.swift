//
//  MeasuringTapeViewController.swift
//  Cubie
//
//  Created by Jordan.Dixon on 11/08/2017.
//  Copyright © 2017 Mubaloo. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class MeasuringTapeViewController: UIViewController, ARSCNViewDelegate {
    
    static let example = ARExample(title: "Measuring Distances",
                                   subtitle: "Measure the distance between two points",
                                   instance: MeasuringTapeViewController.self)
    
    var sceneView: ARSCNView!
    var spheres = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.frame)
        view.addSubview(sceneView)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        addCrosshair()
        registerGestures()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    private func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        
        guard let sceneView = recognizer.view as? ARSCNView else { return }
        let crossHair = self.sceneView.center
        
        // feature points are quickest to find and also can be found on irregular surfaces
        let hitTest = sceneView.hitTest(crossHair, types: .estimatedHorizontalPlane)
        
        guard let hitResult = hitTest.first else { return }
        
        let sphere = SCNSphere(radius: 0.005)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        sphere.firstMaterial = material
        
        let sphereNode = SCNNode(geometry: sphere)
        // .worldTransform is a matrix multiplation to get the position in the world
        sphereNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,
                                         hitResult.worldTransform.columns.3.y,
                                         hitResult.worldTransform.columns.3.z)
        
        self.sceneView.scene.rootNode.addChildNode(sphereNode)
        
        spheres.append(sphereNode)
        if spheres.count == 2 {
            
            calculateDistance(between: spheres)
            spheres.removeAll()
        }
        
    }
    
    private func calculateDistance(between spheres: [SCNNode]) {
        let firstPoint = spheres.first!
        let secondPoint = spheres.last!
        
        let position = SCNVector3Make(secondPoint.position.x - firstPoint.position.x,
                                      secondPoint.position.y - firstPoint.position.y,
                                      secondPoint.position.z - firstPoint.position.z)
        
        let result = sqrt(position.x * position.x + position.y * position.y + position.z * position.z)
        
        // middlePoint = (x1 + x2) / 2, (y1 + y2) / 2, (z1 + z2) / 2
        let center = SCNVector3((firstPoint.position.x + secondPoint.position.x) / 2,
                                (firstPoint.position.y + secondPoint.position.y) / 2,
                                (firstPoint.position.z + secondPoint.position.z) / 2)
        
        displayDistance(from: result, at: center)
        
    }
    
    private func displayDistance(from distance: Float, at position: SCNVector3) {
        
        let text = SCNText(string: "\(distance * 100) cm", extrusionDepth: 1.0)
        text.firstMaterial?.diffuse.contents = UIColor.black
        
        let textNode = SCNNode(geometry: text)
        textNode.position = position
        
        textNode.scale = SCNVector3(0.002, 0.002, 0.002)
        
        self.sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    private func addCrosshair() {
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 33))
        label.text = "+"
        label.textAlignment = .center
        label.center = self.sceneView.center
        
        self.sceneView.addSubview(label)
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

